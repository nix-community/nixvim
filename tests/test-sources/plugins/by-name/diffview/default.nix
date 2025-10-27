{
  empty = {
    plugins.web-devicons.enable = true;
    plugins.diffview.enable = true;
  };

  example = {
    plugins.web-devicons.enable = true;
    plugins.diffview = {
      enable = true;

      settings = {
        diff_binaries = true;
        enhanced_diff_hl = true;
        git_cmd = [ "git" ];
        hg_cmd = [ "hg" ];
        use_icons = false;
        show_help_hints = false;
        watch_index = true;
        icons = {
          folder_closed = "a";
          folder_open = "b";
        };
        signs = {
          fold_closed = "c";
          fold_open = "d";
          done = "e";
        };
        view = {
          default = {
            layout = "diff2_horizontal";
            winbar_info = true;
          };
          merge_tool = {
            layout = "diff1_plain";
            disable_diagnostics = false;
            winbar_info = false;
          };
          file_history = {
            layout = "diff2_vertical";
            winbar_info = true;
          };
        };
        file_panel = {
          listing_style = "list";
          tree_options = {
            flatten_dirs = false;
            folder_statuses = "never";
          };
          win_config = {
            position = "right";
            width = 20;
            win_opts.__empty = { };
          };
        };
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                base = "a";
                diff_merges = "combined";
              };
              multi_file.diff_merges = "first-parent";
            };
            hg = {
              single_file.__empty = { };
              multi_file.__empty = { };
            };
          };
          win_config = {
            position = "top";
            height = 10;
            win_opts.__empty = { };
          };
        };

        commit_log_panel.win_config.win_opts = { };
        default_args = {
          DiffviewOpen = [ "HEAD" ];
          DiffviewFileHistory = [ "%" ];
        };
        hooks = {
          view_opened = ''
            function(view)
              print(
                ("A new %s was opened on tab page %d!")
                :format(view.class:name(), view.tabpage)
              )
            end
          '';
        };
        keymaps = {
          view = [
            {
              mode = "n";
              key = "<tab>";
              action = "actions.select_next_entry";
              description = "Open the diff for the next file";
            }
          ];
          diff1 = [
            {
              mode = "n";
              key = "<tab>";
              action = "actions.select_next_entry";
            }
          ];
          diff2 = [
            {
              mode = "n";
              key = "<tab>";
              action = "actions.select_next_entry";
              description = "Open the diff for the next file";
            }
          ];
          diff3 = [
            {
              mode = "n";
              key = "<tab>";
              action = "actions.select_next_entry";
              description = "Open the diff for the next file";
            }
          ];
          diff4 = [
            {
              mode = "n";
              key = "<tab>";
              action = "actions.select_next_entry";
              description = "Open the diff for the next file";
            }
          ];
          file_panel = [
            {
              mode = "n";
              key = "<tab>";
              action = "actions.select_next_entry";
              description = "Open the diff for the next file";
            }
          ];
          file_history_panel = [
            {
              mode = "n";
              key = "<tab>";
              action = "actions.select_next_entry";
              description = "Open the diff for the next file";
            }
          ];
          option_panel = [
            {
              mode = "n";
              key = "<tab>";
              action = "actions.select_next_entry";
              description = "Open the diff for the next file";
            }
          ];
          help_panel = [
            {
              mode = "n";
              key = "<tab>";
              action = "actions.select_next_entry";
              description = "Open the diff for the next file";
            }
          ];
        };
      };
    };
  };

  no-icons = {
    plugins.web-devicons.enable = false;
    plugins.diffview = {
      enable = true;
    };
  };
}
