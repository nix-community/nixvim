{ helpers, pkgs }:
let
  # Extend nixpkg's lib, so that we can handle recursive leaf types such as `either`
  lib = pkgs.lib.extend (
    final: prev: {
      types = prev.types // {
        either =
          t1: t2:
          (prev.types.either t1 t2)
          // {
            getSubOptions = prefix: (t1.getSubOptions prefix) // (t2.getSubOptions prefix);
          };

        eitherRecursive = t1: t2: (final.types.either t1 t2) // { getSubOptions = _: { }; };

        oneOfRecursive =
          ts:
          let
            head' =
              if ts == [ ] then
                throw "types.oneOfRecursive needs to get at least one type in its argument"
              else
                builtins.head ts;
            tail' = builtins.tail ts;
          in
          builtins.foldl' final.types.eitherRecursive head' tail';
      };
    }
  );

  pkgsDoc = pkgs // {
    inherit lib;
  };

  nixvimPath = toString ./..;

  gitHubDeclaration = user: repo: branch: subpath: {
    url = "https://github.com/${user}/${repo}/blob/${branch}/${subpath}";
    name = "<${repo}/${subpath}>";
  };

  transformOptions =
    opt:
    opt
    // {
      declarations = map (
        decl:
        if lib.hasPrefix nixvimPath (toString decl) then
          gitHubDeclaration "nix-community" "nixvim" "main" (
            lib.removePrefix "/" (lib.removePrefix nixvimPath (toString decl))
          )
        else if decl == "lib/modules.nix" then
          gitHubDeclaration "NixOS" "nixpkgs" "master" decl
        else
          decl
      ) opt.declarations;
    };

  nixvmConfigType = lib.mkOptionType {
    name = "nixvim-configuration";
    description = "nixvim configuration options";
    descriptionClass = "noun";
    # Evaluation is irrelevant, only used for documentation.
  };

  # Construct our own top-level modules, because we want to stub the `files` option
  # FIXME: add a way to handle this with specialArgs
  topLevelModules = [
    ../modules
    ../modules/top-level/output.nix
    # Fake module to avoid a duplicated documentation
    (lib.setDefaultModuleLocation "${nixvimPath}/wrappers/modules/files.nix" {
      options.files = lib.mkOption {
        type = lib.types.attrsOf nixvmConfigType;
        description = "Extra files to add to the runtimepath";
        example = {
          "ftplugin/nix.lua" = {
            options = {
              tabstop = 2;
              shiftwidth = 2;
              expandtab = true;
            };
          };
        };
      };
    })
  ];

  hmOptions = builtins.removeAttrs (lib.evalModules {
    modules = [ (import ../wrappers/modules/hm.nix { inherit lib; }) ];
  }).options [ "_module" ];
in
rec {
  options-json =
    (pkgsDoc.nixosOptionsDoc {
      inherit
        (lib.evalModules {
          modules = topLevelModules;
          specialArgs = {
            inherit helpers;
            defaultPkgs = pkgsDoc;
          };
        })
        options
        ;
      inherit transformOptions;
      warningsAreErrors = false;
    }).optionsJSON;
  man-docs = pkgsDoc.callPackage ./man { inherit options-json; };
}
# Do not check if documentation builds fine on darwin as it fails:
# > sandbox-exec: pattern serialization length 69298 exceeds maximum (65535)
// lib.optionalAttrs (!pkgsDoc.stdenv.isDarwin) {
  docs = pkgsDoc.callPackage ./mdbook {
    inherit transformOptions;
    modules = topLevelModules;
    inherit helpers hmOptions;
  };
}
