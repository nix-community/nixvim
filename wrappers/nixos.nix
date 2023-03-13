modules: {
  pkgs,
  config,
  lib,
  ...
} @ args: let
  inherit (lib) mkEnableOption mkOption mkOptionType mkMerge mkIf types;
  shared = import ./_shared.nix modules args;
  cfg = config.programs.nixvim;
  files =
    shared.configFiles
    // {
      "nvim/sysinit.lua".text = cfg.initContent;
    };
in {
  options = {
    programs.nixvim = mkOption {
      default = {};
      type = types.submodule ([
          {
            options.enable = mkEnableOption "nixvim";
          }
        ]
        ++ shared.topLevelModules);
    };
    nixvim.helpers = shared.helpers;
  };

  config =
    mkIf cfg.enable
    (mkMerge [
      {environment.systemPackages = [cfg.finalPackage];}
      (mkIf (!cfg.wrapRc) {
        environment.etc = files;
        environment.variables."VIM" = "/etc/nvim";
      })
      {
        warnings = cfg.warnings;
        assertions = cfg.assertions;
      }
    ]);
}
