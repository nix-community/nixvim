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
  description = "Neovim plugin for WezTerm, a GPU-accelerated terminal emulator and multiplexer.";

  maintainers = [ lib.maintainers.khaneliman ];

  dependencies = [ "wezterm" ];

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
}
