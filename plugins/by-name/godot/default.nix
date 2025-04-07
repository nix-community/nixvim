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

  maintainers = [ maintainers.GaetanLepage ];

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

  extraConfig = {
    dependencies.godot.enable = lib.mkDefault true;
  };
}
