{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.neovim.mkNeovimPlugin {
  name = "wezterm";
  package = "wezterm-nvim";
  description = "Neovim plugin for WezTerm, a GPU-accelerated terminal emulator and multiplexer.";

  maintainers = [ lib.maintainers.khaneliman ];

  dependencies = [ "wezterm" ];

  settingsOptions = {
    create_commands = defaultNullOpts.mkBool true ''
      Whether to create plugin commands.
    '';
  };

  settingsExample = {
    create_commands = false;
  };
}
