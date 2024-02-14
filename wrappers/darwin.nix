{
  modules,
  self,
  getHelpers,
}: {
  pkgs,
  config,
  lib,
  ...
} @ args: let
  inherit (lib) mkEnableOption mkOption mkOptionType mkForce mkMerge mkIf types;
  helpers = getHelpers pkgs false;
  shared = import ./_shared.nix {inherit modules helpers;} args;
  cfg = config.programs.nixvim;
in {
  options = {
    programs.nixvim = mkOption {
      default = {};
      type = types.submoduleWith {
        shorthandOnlyDefinesConfig = true;
        specialArgs.helpers = helpers;
        modules =
          [
            {
              options.enable = mkEnableOption "nixvim";
              config.wrapRc = mkForce true;
            }
          ]
          ++ shared.topLevelModules;
      };
    };
    nixvim.helpers = shared.helpers;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages =
        [
          cfg.finalPackage
          cfg.printInitPackage
        ]
        ++ (lib.optional cfg.enableMan self.packages.${pkgs.system}.man-docs);
    }
    {
      inherit (cfg) warnings assertions;
    }
  ]);
}
