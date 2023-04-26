modules: {
  pkgs,
  config,
  lib,
  ...
} @ args: let
  inherit (lib) mkEnableOption mkOption mkOptionType mkForce mkMerge mkIf types;
  shared = import ./_shared.nix modules args;
  cfg = config.programs.nixvim;
in {
  options = {
    programs.nixvim = mkOption {
      default = {};
      type = types.submodule ([
          {
            options.enable = mkEnableOption "nixvim";
            config.wrapRc = mkForce true;
          }
        ]
        ++ shared.topLevelModules);
    };
    nixvim.helpers = shared.helpers;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [cfg.finalPackage];
    }
    {
      warnings = cfg.warnings;
      assertions = cfg.assertions;
    }
  ]);
}
