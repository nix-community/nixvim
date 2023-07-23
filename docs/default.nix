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
                  url = "https://github.com/nix-community/nixvim/blob/main/${filepath}";
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
        then {
          index.options = moduleOpts;
          group = "Neovim Options";
        }
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

  removeWhitespace = builtins.replaceStrings [" "] [""];

  mapModulesToString = {
    moduleFunc ? {module, ...}: module,
    submoduleFunc ? {submodule, ...}: submodule,
    componentFunc ? {component, ...}: component,
    subComponentFunc ? {subComponent, ...}: subComponent,
    moduleMapFunc ? mapAttrsToStringSep,
    submoduleMapFunc ? moduleMapFunc,
    componentMapFunc ? submoduleMapFunc,
    subComponentMapFunc ? componentMapFunc,
  }:
    moduleMapFunc (
      group: groupOpts:
        if group != "default"
        then
          moduleFunc {
            module = group;
            moduleOpts = groupOpts;
            path = removeWhitespace group;
            standalone = true;
          }
        else
          moduleMapFunc (
            module: moduleOpts:
              (moduleFunc {
                inherit module moduleOpts;
                path = removeWhitespace module;
                standalone = moduleOpts ? "index";
              })
              + (
                if !moduleOpts ? "index"
                then
                  submoduleMapFunc (
                    submodule: submoduleOpts:
                      (submoduleFunc {
                        inherit module submodule submoduleOpts;
                        standalone = !(submoduleOpts ? "components") || submoduleOpts.components == {};
                        path = removeWhitespace "${module}/${submodule}";
                      })
                      + (
                        if (submoduleOpts ? "components") && submoduleOpts.components != {}
                        then
                          componentMapFunc (
                            component: componentOpts:
                              (componentFunc {
                                inherit module submodule component componentOpts;
                                standalone = componentOpts ? "options";
                                path = removeWhitespace "${module}/${submodule}/${component}";
                              })
                              + (
                                if !componentOpts ? "options"
                                then
                                  subComponentMapFunc (
                                    subComponent: subComponentOpts:
                                      subComponentFunc {
                                        inherit module submodule component subComponent subComponentOpts;
                                        path = removeWhitespace "${module}/${submodule}/${component}/${subComponent}";
                                      }
                                  )
                                  componentOpts
                                else ""
                              )
                          )
                          submoduleOpts.components
                        else ""
                      )
                  )
                  moduleOpts
                else ""
              )
          )
          groupOpts
    );

  doc = rec {
    modules = foldlAttrs (
      acc: module: opts: let
        group = opts.group or "default";
        last = acc.${group} or {};
      in
        acc
        // {
          ${group} = last // {${module} = opts;};
        }
    ) {} (processModules (removeUnwanted options.options));

    commands =
      mapModulesToString {
        moduleFunc = {
          module,
          moduleOpts,
          path,
          standalone,
          ...
        }:
          if standalone
          then "cp ${mkMDDoc moduleOpts} ${path}.md"
          else "\nmkdir ${module}\n";

        submoduleFunc = {
          submodule,
          submoduleOpts,
          path,
          standalone,
          ...
        }:
          if standalone
          then "cp ${mkMDDoc submoduleOpts.index.options} ${path}.md"
          else ''
            mkdir ${path}
            cp ${mkMDDoc submoduleOpts.index.options} ${path}/index.md
          '';

        componentFunc = {
          component,
          componentOpts,
          path,
          standalone,
          ...
        }:
          if standalone
          then "cp ${mkMDDoc componentOpts.options} ${path}.md"
          else "mkdir ${path}\n";

        subComponentFunc = {
          subComponent,
          subComponentOpts,
          path,
          ...
        }: "cp ${mkMDDoc subComponentOpts.options} ${path}.md";

        moduleMapFunc = mapAttrsToStringSep;
      }
      modules;
  };

  # Options used to substitute variables in mdbook generation
  mdbook = {
    nixvimOptions =
      mapModulesToString {
        moduleFunc = {
          module,
          path,
          standalone,
          ...
        }:
          if standalone
          then "- [${module}](${path}.md)"
          else "- [${module}]()\n";

        submoduleFunc = {
          submodule,
          path,
          standalone,
          ...
        }:
          if standalone
          then "\t- [${submodule}](${path}.md)"
          else "\t- [${submodule}](${path}/index.md)\n";

        componentFunc = {
          component,
          path,
          standalone,
          ...
        }:
          if standalone
          then "\t\t- [${component}](${path}.md)"
          else "\t\t- [${component}](${path}/index.md)\n";

        subComponentFunc = {
          subComponent,
          path,
          ...
        }: "\t\t\t- [${subComponent}](${path}.md)";

        moduleMapFunc = mapAttrsToStringSep;
      }
      doc.modules;
  };

  prepareMD = ''
    # Copy inputs into the build directory
    cp -r --no-preserve=all $inputs/* ./
    cp ${../CONTRIBUTING.md} ./CONTRIBUTING.md

    # Copy the generated md docs into the build directory
    ${doc.commands}

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
      ${prepareMD}
      mkdir $dest/.tmp && cp -r . $dest/.tmp # TODO: remove
      mdbook build
      cp -r ./book/* $dest
    '';
  }
