{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "kitty-scrollback";
  package = "kitty-scrollback-nvim";

  maintainers = [ lib.maintainers.nim65s ];

  settingsExample = lib.literalExpression ''
    {
      # create your config
      myconfig.kitty_get_text.ansi = false;
      # or extend a builtin one
      ksb_builtin_last_cmd_output.ansi = false;
    }
  '';
}
