{
  rawModules,
  helpers,
  pkgs,
}:
let
  pkgsDoc =
    import
      (pkgs.applyPatches {
        name = "nixpkgs-nixvim-doc";
        src = pkgs.path;
        patches = [ ./either_recursive.patch ];
      })
      {
        inherit (pkgs) system;
        config.allowUnfree = true;
      };

  inherit (pkgsDoc) lib;

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

  topLevelModules = [
    ../wrappers/modules/output.nix
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
  ] ++ (rawModules pkgsDoc);

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
          specialArgs.helpers = helpers;
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
