{ lib }:
{
  empty =
    { config, ... }:
    {
      # TODO: 2026-07-12 dependency python3.frictionless has a build failure
      test.buildNixvim = false;

      plugins.vectorcode.enable = true;

      assertions = [
        {
          assertion = !(lib.hasInfix "require('vectorcode').setup(" config.content);
          message = "Empty vectorcode config should not emit a setup call.";
        }
      ];
    };

  codecompanion-integration =
    let
      extensionSettings = {
        tool_group.enabled = true;
        tool_opts.query.default_num = {
          chunk = 50;
          document = 10;
        };
      };
    in
    { config, ... }:
    {
      test.buildNixvim = false;

      plugins.codecompanion.enable = true;

      plugins.vectorcode = {
        enable = true;
        integrations.codecompanion = {
          enable = true;
          settings = extensionSettings;
        };
      };

      assertions = [
        {
          assertion =
            config.plugins.codecompanion.settings.extensions.vectorcode == {
              enabled = true;
              opts = extensionSettings;
            };
          message = "VectorCode CodeCompanion integration should configure the extension.";
        }
      ];
    };

  codecompanion-integration-missing-codecompanion = {
    test = {
      buildNixvim = false;
      assertions = expect: [
        (expect "any" "VectorCode's CodeCompanion integration requires `plugins.codecompanion.enable = true`.")
      ];
    };

    plugins.vectorcode = {
      enable = true;
      integrations.codecompanion.enable = true;
    };
  };

  defaults = {
    # TODO: 2026-07-12 dependency python3.frictionless has a build failure
    test.buildNixvim = false;

    plugins.vectorcode = {
      enable = true;
      settings = {
        cli_cmds.vectorcode = "vectorcode";
        async_opts = {
          debounce = 10;
          events = [
            "BufWritePost"
            "InsertEnter"
            "BufReadPost"
          ];
          exclude_this = true;
          n_query = 1;
          notify = false;
          query_cb = lib.nixvim.mkRaw ''require("vectorcode.utils").make_surrounding_lines_cb(-1)'';
          run_on_register = false;
          single_job = false;
          timeout_ms = 5000;
        };
        async_backend = "default";
        exclude_this = true;
        n_query = 1;
        notify = true;
        timeout_ms = 5000;
        on_setup = {
          update = false;
          lsp = false;
        };
        sync_log_env_var = false;
      };
    };
  };

  example = {
    # TODO: 2026-07-12 dependency python3.frictionless has a build failure
    test.buildNixvim = false;

    plugins.vectorcode = {
      enable = true;
      settings = {
        async_backend = "lsp";
        n_query = 5;
        sync_log_env_var = true;
      };
    };
  };
}
