{
  empty = {
    # We do not provide the required HF_API_KEY environment variable.
    test.runNvim = false;

    plugins = {
      cmp.enable = true;
      cmp-ai.enable = true;
    };
  };

  example = {
    # We do not provide the required HF_API_KEY environment variable.
    test.runNvim = false;

    plugins = {
      cmp.enable = true;
      cmp-ai.enable = true;
      cmp-ai.settings = {
        max_lines = 1000;
        provider = "HF";
        notify = true;
        notify_callback = ''
          function(msg)
            vim.notify(msg)
          end
        '';
        run_on_every_keystroke = true;
        ignored_file_types = {
          lua = true;
        };
      };
    };
  };
}
