{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "claude-code";
  packPathName = "claude-code.nvim";
  package = "claude-code-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    window = {
      split_ratio = 0.4;
      position = "vertical";
      hide_numbers = false;
      hide_signcolumn = false;
    };
  };
}
