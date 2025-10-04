{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "copilot-lsp";
  package = "copilot-lsp";

  description = ''
    A lightweight and extensible Neovim plugin for integrating GitHub Copilot's AI-powered
    code suggestions via Language Server Protocol (LSP).

    > [!NOTE]
    > This plugin requires the `copilot-language-server`.
    > Either enable through `copilot-lua` plugin or install manually.
  '';

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    nes = {
      move_count_threshold = 5;
      distance_threshold = 100;
      reset_on_approaching = false;
    };
  };
}
