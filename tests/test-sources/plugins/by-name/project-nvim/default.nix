{
  empty = {
    plugins.project-nvim = {
      enable = true;

      # The default datapath is unwritable in the sandbox
      settings.datapath.__raw = "os.getenv('TMPDIR')";
    };
  };

  telescopeEnabled = {
    plugins.telescope = {
      enable = true;
    };
    plugins.project-nvim = {
      enable = true;
      enableTelescope = true;

      # The default datapath is unwritable in the sandbox
      settings.datapath.__raw = "os.getenv('TMPDIR')";
    };
    plugins.web-devicons.enable = true;
  };

  defaults = {
    # Attempts at writing to `datapath`:
    # ERROR: Invalid `datapath`, reverting to default.
    test.runNvim = false;

    plugins.project-nvim = {
      enable = true;
      settings = {
        manual_mode = false;
        lsp = {
          enabled = true;
          ignore.__empty = { };
        };
        patterns = [
          ".git"
          "_darcs"
          ".hg"
          ".bzr"
          ".svn"
          "Makefile"
          "package.json"
        ];
        exclude_dirs.__empty = { };
        show_hidden = false;
        silent_chdir = true;
        scope_chdir = "global";
        datapath.__raw = "vim.fn.stdpath('data')";
      };
    };
  };
}
