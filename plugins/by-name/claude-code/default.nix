{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "claude-code";
  packPathName = "claude-code.nvim";
  package = "claude-code-nvim";
  description = "Seamless integration between Claude Code AI assistant and Neovim";

  maintainers = [ lib.maintainers.khaneliman ];

  dependencies = [
    "claude-code"
  ];

  settingsExample = {
    window = {
      split_ratio = 0.4;
      position = "vertical";
      hide_numbers = false;
      hide_signcolumn = false;
    };
  };
}
