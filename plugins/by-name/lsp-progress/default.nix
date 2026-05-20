{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lsp-progress";
  package = "lsp-progress-nvim";
  description = "A performant LSP progress status for Neovim.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    decay = 1200;
    max_size = 80;
    format = lib.nixvim.nestedLiteralLua ''
      function(client_messages)
        return #client_messages > 0 and table.concat(client_messages, " ") or ""
      end
    '';
  };
}
