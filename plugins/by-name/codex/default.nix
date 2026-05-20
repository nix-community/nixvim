{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "codex";
  package = "codex-nvim";
  description = "A Copilot-style coding assistant integration for Neovim.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    keymaps = {
      toggle = "<leader>ac";
    };
    border = "rounded";
    model = "gpt-5-codex";
  };
}
