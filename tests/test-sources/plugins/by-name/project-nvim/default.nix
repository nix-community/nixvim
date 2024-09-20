{
  empty = {
    plugins.project-nvim.enable = true;
  };

  telescopeEnabled = {
    plugins.telescope = {
      enable = true;
    };
    plugins.project-nvim = {
      enable = true;
      enableTelescope = true;
    };
    plugins.web-devicons.enable = true;
  };

  defaults = {
    plugins.project-nvim = {
      enable = true;
      settings = {
        manual_mode = false;
        detection_methods = [
          "lsp"
          "pattern"
        ];
        patterns = [
          ".git"
          "_darcs"
          ".hg"
          ".bzr"
          ".svn"
          "Makefile"
          "package.json"
        ];
        ignore_lsp = [ ];
        exclude_dirs = [ ];
        show_hidden = false;
        silent_chdir = true;
        scope_chdir = "global";
        data_path.__raw = "vim.fn.stdpath('data')";
      };
    };
  };
}
