{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.file-browser.enable = true;
    };
    plugins.web-devicons.enable = true;
  };

  defaults = {
    plugins.telescope = {
      enable = true;

      extensions.file-browser = {
        enable = true;

        settings = {
          theme = null;
          path.__raw = "vim.loop.cwd()";
          cwd.__raw = "vim.loop.cwd()";
          cwd_to_path = false;
          grouped = false;
          files = true;
          add_dirs = true;
          depth = 1;
          auto_depth = false;
          select_buffer = false;
          hidden = {
            file_browser = false;
            folder_browser = false;
          };
          respect_gitignore = false;
          browse_files = "require('telescope._extensions.file_browser.finders').browse_files";
          browse_folders = "require('telescope._extensions.file_browser.finders').browse_folders";
          hide_parent_dir = false;
          collapse_dirs = false;
          quiet = false;
          dir_icon = "";
          dir_icon_hl = "Default";
          display_stat = {
            date = true;
            size = true;
            mode = true;
          };
          hijack_netrw = false;
          use_fd = true;
          git_status = true;
          prompt_path = false;
          mappings = {
            i = {
              "<A-c>" = "require('telescope._extensions.file_browser.actions').create";
              "<S-CR>" = "require('telescope._extensions.file_browser.actions').create_from_prompt";
              "<A-r>" = "require('telescope._extensions.file_browser.actions').rename";
              "<A-m>" = "require('telescope._extensions.file_browser.actions').move";
              "<A-y>" = "require('telescope._extensions.file_browser.actions').copy";
              "<A-d>" = "require('telescope._extensions.file_browser.actions').remove";
              "<C-o>" = "require('telescope._extensions.file_browser.actions').open";
              "<C-g>" = "require('telescope._extensions.file_browser.actions').goto_parent_dir";
              "<C-e>" = "require('telescope._extensions.file_browser.actions').goto_home_dir";
              "<C-w>" = "require('telescope._extensions.file_browser.actions').goto_cwd";
              "<C-t>" = "require('telescope._extensions.file_browser.actions').change_cwd";
              "<C-f>" = "require('telescope._extensions.file_browser.actions').toggle_browser";
              "<C-h>" = "require('telescope._extensions.file_browser.actions').toggle_hidden";
              "<C-s>" = "require('telescope._extensions.file_browser.actions').toggle_all";
              "<bs>" = "require('telescope._extensions.file_browser.actions').backspace";
            };
            n = {
              "c" = "require('telescope._extensions.file_browser.actions').create";
              "r" = "require('telescope._extensions.file_browser.actions').rename";
              "m" = "require('telescope._extensions.file_browser.actions').move";
              "y" = "require('telescope._extensions.file_browser.actions').copy";
              "d" = "require('telescope._extensions.file_browser.actions').remove";
              "o" = "require('telescope._extensions.file_browser.actions').open";
              "g" = "require('telescope._extensions.file_browser.actions').goto_parent_dir";
              "e" = "require('telescope._extensions.file_browser.actions').goto_home_dir";
              "w" = "require('telescope._extensions.file_browser.actions').goto_cwd";
              "t" = "require('telescope._extensions.file_browser.actions').change_cwd";
              "f" = "require('telescope._extensions.file_browser.actions').toggle_browser";
              "h" = "require('telescope._extensions.file_browser.actions').toggle_hidden";
              "s" = "require('telescope._extensions.file_browser.actions').toggle_all";
            };
          };
        };
      };
    };
    plugins.web-devicons.enable = true;
  };
}
