{ lib }:
{
  empty =
    { config, ... }:
    {
      plugins.vectorcode.enable = true;

      assertions = [
        {
          assertion = !(lib.hasInfix "require('vectorcode').setup(" config.content);
          message = "Empty vectorcode config should not emit a setup call.";
        }
      ];
    };

  defaults = {
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
