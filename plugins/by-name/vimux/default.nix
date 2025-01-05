{ lib, pkgs, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vimux";
  globalPrefix = "Vimux";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions = {
    tmuxPackage = lib.mkPackageOption pkgs "tmux" {
      nullable = true;
    };
  };

  extraConfig = cfg: {
    extraPackages = [ cfg.tmuxPackage ];
  };

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    Height = "25";
    Orientation = "h";
    UseNearest = 0;
  };
}
