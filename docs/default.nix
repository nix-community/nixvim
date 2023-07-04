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

  doc =
    foldlAttrs (acc: mod: opts: let
      isStandalone = hasAttr "type" opts;
    in rec {
      modules =
        acc.modules
        // (
          if isStandalone
          then {${mod} = "${mod}.md";}
          else {${mod} = mapAttrs (sub: _: "${mod}/${sub}.md") (removeUnwanted opts);}
        );

      commands =
        acc.commands
        ++ (
          if isStandalone
          then ["cp ${mkMDDoc opts} ${modules.${mod}}\n\n"]
          else [
            ''
              mkdir -p ${mod}
              ${
                concatStrings (
                  mapAttrsToList
                  (
                    sub: opts: ''
                      cp ${mkMDDoc opts} ${modules.${mod}.${sub}}
                    ''
                  ) (removeUnwanted opts)
                )
              }
            ''
          ]
        );
    }) {
      commands = [];
      modules = {};
    }
    (removeUnwanted options.options);

  # Options used to substitute variables in mdbook generation
  mdbook = {
    nixvimOptions = with builtins;
      concatStrings (
        mapAttrsToList (
          mod: opts:
            if typeOf opts == "string"
            then "- [${mod}](${opts})\n"
            else ''
              - [${mod}](${mod}/index.md)
              ${concatStringsSep "\n" (
                mapAttrsToList (
                  sub: subOpts: "\t- [${sub}](${subOpts})"
                )
                opts
              )}
            ''
        )
        doc.modules
      );
  };

  prepareMD = ''
    # Copy inputs into the build directory
    cp -r $inputs/* ./

    # Copy generated docs to dest
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
      mdbook build
      cp -r ./book/* $dest
      mkdir $dest/.tmp && cp -r . $dest/.tmp # TODO: remove
    '';
  }
