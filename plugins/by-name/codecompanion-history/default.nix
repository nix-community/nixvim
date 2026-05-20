{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "codecompanion-history";
  package = "codecompanion-history-nvim";
  description = "Persists and reuses CodeCompanion chats from within Neovim.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsDescription = "Configuration merged into `plugins.codecompanion.settings.extensions.history.opts`.";

  settingsExample = {
    auto_save = false;
    picker = "snacks";
    continue_last_chat = true;
    title_generation_opts = {
      model = "gpt-4o-mini";
      refresh_every_n_prompts = 3;
    };
    summary.generation_opts.model = "gpt-4o-mini";
    memory = {
      notify = false;
      index_on_startup = true;
    };
  };

  callSetup = false;
  hasLuaConfig = false;

  extraConfig = cfg: {
    plugins.codecompanion = {
      enable = lib.mkDefault true;
      settings.extensions.history = {
        enabled = true;
        opts = cfg.settings;
      };
    };
  };
}
