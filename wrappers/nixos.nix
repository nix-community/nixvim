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
  helpers = getHelpers pkgs;
  shared = import ./_shared.nix {inherit modules helpers;} args;
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
      type = types.submoduleWith {
        shorthandOnlyDefinesConfig = true;
        specialArgs.helpers = helpers;
        modules =
          [
            {
              options = {
                enable = mkEnableOption "nixvim";
                defaultEditor = mkEnableOption "nixvim as the default editor";
              };
              config.wrapRc = mkForce true;
            }
          ]
          ++ shared.topLevelModules;
      };
    };
    nixvim.helpers = shared.helpers;
  };

  config =
    mkIf cfg.enable
    (mkMerge [
      {
        environment.systemPackages =
          [
            cfg.finalPackage
            cfg.printInitPackage
          ]
          ++ (lib.optional cfg.enableMan self.packages.${pkgs.system}.man-docs);
      }
      (mkIf (!cfg.wrapRc) {
        environment.etc = files;
        environment.variables."VIM" = "/etc/nvim";
      })
      {
        inherit (cfg) warnings assertions;
        programs.neovim.defaultEditor = cfg.defaultEditor;
        environment.variables.EDITOR = mkIf cfg.defaultEditor (lib.mkOverride 900 "nvim");
      }
    ]);
}
