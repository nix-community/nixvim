{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "vectorcode";
  package = "vectorcode-nvim";
  description = "Code-aware local retrieval and completion integration for Neovim.";
  callSetup = "optional";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    async_backend = "lsp";
    n_query = 5;
    sync_log_env_var = true;
  };

  dependencies = [
    "vectorcode"
  ];
}
