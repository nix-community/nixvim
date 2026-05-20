{
  config,
  lib,
  ...
}:
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

  extraOptions = {
    integrations.codecompanion = {
      enable = lib.mkEnableOption "the vectorcode extension for CodeCompanion";

      settings = lib.mkOption {
        type = lib.nixvim.lua-types.tableOf lib.nixvim.lua-types.anything;
        default = { };
        example = {
          tool_group.enabled = true;
          tool_opts.query.max_num = {
            chunk = -1;
            document = -1;
          };
        };
        description = ''
          Options passed to CodeCompanion's vectorcode extension.
        '';
      };
    };
  };

  extraConfig = cfg: {
    plugins.codecompanion.settings.extensions.vectorcode =
      lib.mkIf cfg.integrations.codecompanion.enable
        {
          enabled = true;
          opts = cfg.integrations.codecompanion.settings;
        };

    assertions = lib.nixvim.mkAssertions "plugins.vectorcode" {
      assertion = cfg.integrations.codecompanion.enable -> config.plugins.codecompanion.enable;
      message = ''
        VectorCode's CodeCompanion integration requires `plugins.codecompanion.enable = true`.
      '';
    };
  };
}
