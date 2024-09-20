{
  empty = {
    # A warning is displayed on stdout
    test.runNvim = false;

    plugins.telescope = {
      enable = true;
      extensions.frecency.enable = true;
    };
    plugins.web-devicons.enable = true;
  };

  defaults = {
    # A warning is displayed on stdout
    test.runNvim = false;

    plugins.telescope = {
      enable = true;

      extensions.frecency = {
        enable = true;

        settings = {
          auto_validate = true;
          db_root.__raw = "vim.fn.stdpath 'data'";
          db_safe_mode = true;
          db_validate_threshold = 10;
          default_workspace = null;
          disable_devicons = false;
          hide_current_buffer = false;
          filter_delimiter = ":";
          ignore_patterns = [
            "*.git/*"
            "*/tmp/*"
            "term://*"
          ];
          max_timestamps = 10;
          show_filter_column = true;
          show_scores = false;
          show_unindexed = true;
          workspace_scan_cmd = null;
          workspaces = { };
        };
      };
    };
    plugins.web-devicons.enable = true;
  };

  example = {
    # A warning is displayed on stdout
    test.runNvim = false;

    plugins.telescope = {
      enable = true;

      extensions.frecency = {
        enable = true;

        settings = {
          db_root = "/home/my_username/path/to/db_root";
          show_scores = false;
          show_unindexed = true;
          ignore_patterns = [
            "*.git/*"
            "*/tmp/*"
          ];
          disable_devicons = false;
          workspaces = {
            conf = "/home/my_username/.config";
            data = "/home/my_username/.local/share";
            project = "/home/my_username/projects";
            wiki = "/home/my_username/wiki";
          };
        };
      };
    };
    plugins.web-devicons.enable = true;
  };
}
