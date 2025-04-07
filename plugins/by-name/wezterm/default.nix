{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.neovim.mkNeovimPlugin {
  name = "wezterm";
  packPathName = "wezterm.nvim";
  package = "wezterm-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "wezterm";
      packageName = "wezterm";
    })
  ];

  settingsOptions = {
    create_commands = defaultNullOpts.mkBool true ''
      Whether to create plugin commands.
    '';
  };

  settingsExample = {
    create_commands = false;
  };

  extraConfig = {
    dependencies.wezterm.enable = lib.mkDefault true;
  };
}
