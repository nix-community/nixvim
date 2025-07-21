{
  empty = {
    plugins.web-devicons.enable = true;
    plugins.nvim-tree.enable = true;
  };

  defaults = {
    plugins.web-devicons.enable = true;
    plugins.nvim-tree = {
      openOnSetup = true;
      openOnSetupFile = true;
      autoClose = true;
      ignoreBufferOnSetup = true;
      ignoreFtOnSetup = [ "tex" ];
      settings = {
        disable_netrw = true;
        hijack_netrw = false;
        auto_reload_on_write = true;
        sort_by = "name";
        hijack_unnamed_buffer_when_opening = false;
        hijack_cursor = false;
        root_dirs = [ ];
        prefer_startup_root = false;
        sync_root_with_cwd = false;
        reload_on_bufenter = false;
        respect_buf_cwd = false;
        hijack_directories = {
          enable = true;
          auto_open = true;
        };
        update_focused_file = {
          enable = false;
          update_root = false;
          ignore_list = [ ];
        };
        system_open = {
          cmd = "";
          args = [ ];
        };
        diagnostics = {
          enable = false;
          debounce_delay = 50;
          show_on_dirs = false;
          show_on_open_dirs = true;
          icons = {
            hint = "";
            info = "";
            warning = "";
            error = "";
          };
          severity = {
            min = "hint";
            max = "error";
          };
        };
        git = {
          enable = true;
          ignore = true;
          show_on_dirs = true;
          show_on_open_dirs = true;
          timeout = 400;
        };
        modified = {
          enable = false;
          show_on_dirs = true;
          show_on_open_dirs = true;
        };
        filesystem_watchers = {
          enable = true;
          debounce_delay = 50;
          ignore_dirs = [ ];
        };
        on_attach = "default";
        select_prompts = false;
        view = {
          centralize_selection = false;
          cursorline = true;
          debounce_delay = 15;
          width = {
            min = 30;
            max = -1;
            padding = 1;
          };
          side = "left";
          preserve_window_proportions = false;
          number = false;
          relativenumber = false;
          signcolumn = "yes";
          float = {
            enable = false;
            quit_on_focus_loss = true;
            open_win_config = {
              col = 1;
              row = 1;
              relative = "cursor";
              border = "shadow";
              style = "minimal";
            };
          };
        };
        renderer = {
          add_trailing = false;
          group_empty = false;
          full_name = false;
          highlight_git = false;
          highlight_opened_files = "none";
          highlight_modified = "none";
          root_folder_label = ":~:s?$?/..?";
          indent_width = 2;
          indent_markers = {
            enable = false;
            inline_arrows = true;
            icons = {
              corner = "└";
              edge = "│";
              item = "│";
              bottom = "─";
              none = " ";
            };
          };
          icons = {
            webdev_colors = true;
            git_placement = "before";
            modified_placement = "after";
            padding = " ";
            symlink_arrow = " ➛ ";
            show = {
              file = true;
              folder = true;
              folder_arrow = true;
              git = true;
              modified = true;
            };
            glyphs = {
              default = "";
              symlink = "";
              modified = "●";
              folder = {
                arrow_closed = "";
                arrow_open = "";
                default = "";
                open = "";
                empty = "";
                empty_open = "";
                symlink = "";
                symlink_open = "";
              };
              git = {
                unstaged = "✗";
                staged = "✓";
                unmerged = "";
                renamed = "➜";
                untracked = "★";
                deleted = "";
                ignored = "◌";
              };
            };
          };
          special_files = [
            "Cargo.toml"
            "Makefile"
            "README.md"
            "readme.md"
          ];
          symlink_destination = true;
        };
        filters = {
          dotfiles = false;
          git_clean = false;
          no_buffer = false;
          custom = [ ];
          exclude = [ ];
        };
        actions = {
          change_dir = {
            enable = true;
            global = false;
            restrict_above_cwd = false;
          };
          expand_all = {
            max_folder_discovery = 300;
            exclude = [ ];
          };
          file_popup = {
            open_win_config = {
              col = 1;
              row = 1;
              relative = "cursor";
              border = "shadow";
              style = "minimal";
            };
          };
          open_file = {
            quit_on_open = false;
            resize_window = true;
          };
          window_picker = {
            enable = true;
            picker = "default";
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
            exclude = {
              filetype = [
                "notify"
                "packer"
                "qf"
                "diff"
                "fugitive"
                "fugitiveblame"
              ];
              buftype = [
                "nofile"
                "terminal"
                "help"
              ];
            };
          };
          remove_file = {
            close_window = true;
          };
          use_system_clipboard = true;
        };
        live_filter = {
          prefix = "[FILTER]: ";
          always_show_folders = true;
        };
        tab = {
          sync = {
            open = false;
            close = false;
            ignore = [ ];
          };
        };
        notify = {
          threshold = "info";
        };
        ui = {
          confirm = {
            remove = true;
            trash = true;
          };
        };
        log = {
          enable = false;
          truncate = false;
          types = {
            all = false;
            profile = false;
            config = false;
            copy_paste = false;
            dev = false;
            diagnostics = false;
            git = false;
            watcher = false;
          };
        };
      };
    };
  };

  no-packages = {
    plugins = {
      web-devicons.enable = true;
      nvim-tree.enable = true;
    };

    dependencies.git.enable = false;
  };
}
