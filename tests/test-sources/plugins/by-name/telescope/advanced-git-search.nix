{
  empty = {
    plugins = {
      telescope = {
        enable = true;
        extensions.advanced-git-search.enable = true;
      };
      web-devicons.enable = true;
    };
  };

  defaults = {
    plugins = {
      web-devicons.enable = true;
      telescope = {
        enable = true;

        extensions.advanced-git-search = {
          enable = true;

          settings = {
            browse_command = "GBrowse {commit_hash}";
            diff_plugin = "fugitive";
            git_flags = [ ];
            git_diff_flags = [ ];
            git_log_flags = [ ];
            show_builtin_git_pickers = false;

            entry_default_author_or_date = "author";
            keymaps = {
              toggle_date_author = "<C-w>";
              open_commit_in_browser = "<C-o>";
              copy_commit_hash = "<C-y>";
              show_entire_commit = "<C-e>";
            };
          };
        };
      };
    };
  };

  example = {
    plugins = {
      web-devicons.enable = true;
      telescope = {
        enable = true;

        extensions.advanced-git-search = {
          enable = true;

          settings = {
          };
        };
      };
    };
  };
}
