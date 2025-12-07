{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "godot";
  package = "vim-godot";
  globalPrefix = "godot_";
  description = "A Neovim plugin for Godot game engine integration.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "godot" ];

  settingsOptions = {
    executable = lib.nixvim.defaultNullOpts.mkStr "godot" ''
      Path to the `godot` executable.
    '';
  };

  settingsExample = {
    executable = "godot";
  };
}
