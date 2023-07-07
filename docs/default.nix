{
  pkgs,
  lib,
  modules,
  ...
}:
with lib; let
  options = lib.evalModules {
    inherit modules;
    specialArgs = {inherit pkgs lib;};
  };

  mkMDDoc = options:
    (pkgs.nixosOptionsDoc {
      options = filterAttrs (k: _: k != "_module") options;
      warningsAreErrors = false;
      transformOptions = opts:
        opts
        // {
          declarations = with builtins;
            map
            (
              decl:
                if hasPrefix "/nix/store/" decl
                then let
                  filepath = toString (match "^/nix/store/[^/]*/(.*)" decl);
                in {
                  url = "https://github.com/pta2002/nixvim/blob/main/${filepath}";
                  name = filepath;
                }
                else decl
            )
            opts.declarations;
        };
    })
    .optionsCommonMark;

  removeUnwanted = attrs: builtins.removeAttrs attrs ["_module" "warnings" "assertions" "content"];

  isStandalone = opts:
    if isOption opts
    then true
    else false;

  hasSubComponents = componentOpts: all (x: x) (mapAttrsToList (_: opts: !(isStandalone opts)) componentOpts);

  processModules =
    mapAttrsRecursiveCond (set:
      if set ? type
      then false
      else if !isStandalone set
      then false
      else true)
    (
      path: moduleOpts:
        if isStandalone moduleOpts
        then {index.options = moduleOpts;}
        else
          mapAttrs (
            submodule: submoduleOpts:
              if isStandalone submoduleOpts
              then {index.options = submoduleOpts;}
              else
                foldlAttrs (
                  acc: component: componentOpts: {
                    index.options =
                      acc.index.options
                      // (optionalAttrs (isStandalone componentOpts) {
                        ${component} = componentOpts;
                      });

                    components =
                      acc.components
                      // (optionalAttrs (!isStandalone componentOpts) {
                        ${component} =
                          if (!hasSubComponents componentOpts)
                          then {
                            options = componentOpts;
                            path = "${concatStringsSep "/" path}/${submodule}/${component}.md";
                          }
                          else
                            mapAttrs (subComponent: subComponentOpts: {
                              options = subComponentOpts;
                              path = "${concatStringsSep "/" path}/${submodule}/${component}/${subComponent}.md";
                            })
                            componentOpts;
                      });
                  }
                ) {
                  index.options = {};
                  components = {};
                }
                submoduleOpts
          )
          moduleOpts
    );

  mapAttrsToStringSep = f: attrs: concatStringsSep "\n" (mapAttrsToList f attrs);

  doc = rec {
    modules = processModules (removeUnwanted options.options);
    commands =
      mapAttrsToList (
        module: moduleOpts:
          if moduleOpts ? "index"
          then "cp ${mkMDDoc moduleOpts} ${module}.md\n"
          else ''
            mkdir ${module}
            ${mapAttrsToStringSep (
                submodule: submoduleOpts:
                  if !(submoduleOpts ? "components") || submoduleOpts.components == {}
                  then "cp ${mkMDDoc submoduleOpts.index.options} ${module}/${submodule}.md"
                  else ''
                    mkdir ${module}/${submodule}
                    cp ${mkMDDoc submoduleOpts.index.options} ${module}/${submodule}/index.md
                    ${mapAttrsToStringSep
                      (component: componentOpts:
                        if componentOpts ? "options"
                        then "cp ${mkMDDoc componentOpts.options} ${componentOpts.path}"
                        else ''
                          mkdir ${module}/${submodule}/${component}
                          ${mapAttrsToStringSep
                            (
                              subComponentOpts: subComponentOpts: "cp ${mkMDDoc subComponentOpts.options} ${subComponentOpts.path}"
                            )
                            componentOpts}
                        '')
                      submoduleOpts.components}
                  ''
              )
              moduleOpts}
          ''
      )
      modules;
  };

  # Options used to substitute variables in mdbook generation
  mdbook = {
    nixvimOptions =
      mapAttrsToStringSep (
        module: moduleOpts:
          if moduleOpts ? "index"
          then "- [${module}](${module}.md)"
          else
            "- [${module}](${module}/index.md)\n"
            + mapAttrsToStringSep (
              submodule: submoduleOpts:
                if !(submoduleOpts ? "components") || submoduleOpts.components == {}
                then "\t- [${submodule}](${module}/${submodule}.md)"
                else
                  "\t- [${submodule}](${module}/${submodule}/index.md)\n"
                  + mapAttrsToStringSep (
                    component: componentOpts:
                      if componentOpts ? "options"
                      then "\t\t- [${component}](${componentOpts.path})"
                      else
                        "\t\t- [${component}](${module}/${submodule}/${component}/index.md)\n"
                        + (mapAttrsToStringSep (
                            subComponent: subComponentOpts: "\t\t\t- [${subComponent}](${subComponentOpts.path})"
                          )
                          componentOpts)
                  )
                  submoduleOpts.components
            )
            moduleOpts
      )
      doc.modules;
  };

  prepareMD = ''
    # Copy inputs into the build directory
    cp -r --no-preserve=all $inputs/* ./

    # Copy the generated md docs into the build directory
    ${builtins.concatStringsSep "\n" doc.commands}

    # Prepare SUMMARY.md for mdBook
    substituteInPlace ./SUMMARY.md \
      --replace "@NIXVIM_OPTIONS@" "${mdbook.nixvimOptions}"
  '';
in
  pkgs.stdenv.mkDerivation {
    name = "nixvim-docs";

    phases = ["buildPhase"];

    buildInputs = [pkgs.mdbook];
    inputs = sourceFilesBySuffices ./. [".md" ".toml" ".js"];

    buildPhase = ''
      dest=$out/share/doc
      mkdir -p $dest
      echo $dest # TODO: remove
      ${prepareMD}
      mkdir $dest/.tmp && cp -r . $dest/.tmp # TODO: remove
      mdbook build
      cp -r ./book/* $dest
    '';
  }
