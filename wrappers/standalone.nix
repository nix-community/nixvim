default_pkgs: {
  modules,
  self,
  getHelpers,
}: {
  pkgs ? default_pkgs,
  extraSpecialArgs ? {},
  _nixvimTests ? false,
  module,
}: let
  inherit (pkgs) lib;

  helpers = getHelpers pkgs _nixvimTests;
  shared = import ./_shared.nix {inherit modules helpers;} {
    inherit pkgs lib;
    config = {};
  };

  mkEval = mod:
    lib.evalModules {
      modules =
        [
          mod
          {wrapRc = true;}
        ]
        ++ shared.topLevelModules;
      specialArgs =
        {
          inherit helpers;
        }
        // extraSpecialArgs;
    };

  handleAssertions = config: let
    failedAssertions = map (x: x.message) (lib.filter (x: !x.assertion) config.assertions);
  in
    if failedAssertions != []
    then throw "\nFailed assertions:\n${builtins.concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
    else lib.showWarnings config.warnings config;

  mkNvim = mod: let
    config = handleAssertions (mkEval mod).config;
  in
    (pkgs.symlinkJoin {
      name = "nixvim";
      paths =
        [
          config.finalPackage
          config.printInitPackage
        ]
        ++ pkgs.lib.optional config.enableMan self.packages.${pkgs.system}.man-docs;
      meta.mainProgram = "nvim";
    })
    // {
      inherit config;
      nixvimExtend = extension:
        mkNvim {
          imports = [
            mod
            extension
          ];
        };
    };
in
  mkNvim module
