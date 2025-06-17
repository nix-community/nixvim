{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkVimPlugin {
  name = "godot";
  packPathName = "vim-godot";
  package = "vim-godot";
  globalPrefix = "godot_";
  description = "A Neovim plugin for Godot game engine integration.";

  maintainers = [ maintainers.GaetanLepage ];

  dependencies = [ "godot" ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "godot";
      packageName = "godot";
    })
  ];

  settingsOptions = {
    executable = helpers.defaultNullOpts.mkStr "godot" ''
      Path to the `godot` executable.
    '';
  };

  settingsExample = {
    executable = "godot";
  };
}
