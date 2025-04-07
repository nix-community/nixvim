{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vimux";
  globalPrefix = "Vimux";

  maintainers = [ lib.maintainers.GaetanLepage ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "tmux";
      packageName = "tmux";
    })
  ];

  extraConfig = {
    dependencies.tmux.enable = lib.mkDefault true;
  };

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    Height = "25";
    Orientation = "h";
    UseNearest = 0;
  };
}
