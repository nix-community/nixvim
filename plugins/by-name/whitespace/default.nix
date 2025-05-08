{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "whitespace";
  packPathName = "whitespace.nvim";
  moduleName = "whitespace-nvim";
  package = "whitespace-nvim";

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
