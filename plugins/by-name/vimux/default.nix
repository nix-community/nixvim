{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vimux";
  globalPrefix = "Vimux";
  description = "Easily interact with tmux from vim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "tmux" ];

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    Height = "25";
    Orientation = "h";
    UseNearest = 0;
  };
}
