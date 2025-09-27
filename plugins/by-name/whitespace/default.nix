{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "whitespace";
  moduleName = "whitespace-nvim";
  package = "whitespace-nvim";
  description = "A simple neovim plugin to highlight and remove trailing whitespace.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    ignored_filetypes = [
      "Avante"
      "AvanteInput"
      "TelescopePrompt"
      "Trouble"
      "blink-cmp-documentation"
      "blink-cmp-menu"
      "blink-cmp-signature"
      "checkhealth"
      "copilot-chat"
      "dashboard"
      "fzf"
      "help"
      "ministarter"
      "snacks_dashboard"
    ];
    return_cursor = false;
  };
}
