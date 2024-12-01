{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "wezterm";
  originalName = "wezterm.nvim";
  package = "wezterm-nvim";

  maintainers = [ lib.maintainers.samos667 ];

  settingsOptions = {
    create_commands = defaultNullOpts.mkBool true ''
      Whether to create plugin commands.
    '';
  };

  settingsExample = {
    create_commands = false;
  };
}
