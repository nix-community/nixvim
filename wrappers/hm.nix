{
  modules,
  self,
}: {
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
      "nvim/init.lua".text = cfg.initContent;
    };
in {
  options = {
    programs.nixvim = mkOption {
      default = {};
      type = types.submodule ([
          {
            options = {
              enable = mkEnableOption "nixvim";
              defaultEditor = mkEnableOption "nixvim as the default editor";
            };
          }
        ]
        ++ shared.topLevelModules);
    };
    nixvim.helpers = shared.helpers;
  };

  config =
    mkIf cfg.enable
    (mkMerge [
      {
        home.packages =
          [
            cfg.finalPackage
            cfg.printInitPackage
          ]
          ++ (lib.optional cfg.enableMan self.packages.${pkgs.system}.man-docs);
      }
      (mkIf (!cfg.wrapRc) {
        xdg.configFile = files;
      })
      {
        inherit (cfg) warnings assertions;
        home.sessionVariables = mkIf cfg.defaultEditor {EDITOR = "nvim";};
      }
    ]);
}
