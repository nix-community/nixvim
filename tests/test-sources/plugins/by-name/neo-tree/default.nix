{ lib, ... }:
{
  empty = {
    plugins.web-devicons.enable = true;
    plugins.neo-tree = {
      enable = true;

      # Otherwise fail at opening the log file
      # ERROR: [Neo-tree WARN] Could not open log file: /build/.local/share/nvim/neo-tree.nvim.log
      # /build/.local/share/nvim/neo-tree.nvim.log: No such file or directory
      settings.log_to_file = false;
    };
  };

  example = {
    plugins.web-devicons.enable = true;
    plugins.neo-tree = {
      enable = true;

      settings = {
        close_if_last_window = true;
        filesystem.follow_current_file = {
          enabled = true;
          leave_dirs_open = true;
        };

        # Otherwise fail at opening the log file
        # ERROR: [Neo-tree WARN] Could not open log file: /build/.local/share/nvim/neo-tree.nvim.log
        # /build/.local/share/nvim/neo-tree.nvim.log: No such file or directory
        log_to_file = false;
      };
    };
  };

  defaults = {
    plugins.web-devicons.enable = true;
    plugins.neo-tree = {
      enable = true;

      settings = {
        sources = [
          "filesystem"
          "buffers"
          "git_status"
        ];
        add_blank_lLine_at_top = false;
        auto_clean_after_session_sestore = false;
        close_if_last_window = false;
        default_source = "filesystem";
        enable_diagnostics = true;
        enable_git_status = true;
        enable_modified_markers = true;
        enable_refresh_on_write = true;
        git_status_async = true;
        git_status_async_options = {
          batch_size = 1000;
          batch_delay = 10;
          max_lines = 10000;
        };
        hide_root_node = false;
        retain_hidden_root_indent = false;
        log_level = "info";
        log_to_file = false;
        open_files_in_last_window = true;
        popup_border_style = "NC";
        resize_timer_interval = 500;
        sort_case_insensitive = false;
        sort_function.__raw = "nil";
        use_popups_for_input = true;
        use_default_mappings = true;
        source_selector = {
          winbar = false;
          statusline = false;
          show_scrolled_off_parent_node = false;
          sources = [
            {
              source = "filesystem";
              display_name = "  Files ";
            }
            {
              source = "buffers";
              display_name = "  Buffers ";
            }
            {
              source = "gitStatus";
              display_name = "  Git ";
            }
            {
              source = "diagnostics";
              display_name = " 裂Diagnostics ";
            }
          ];
          content_layout = "start";
          tabs_layout = "equal";
          truncation_character = "…";
          tabs_min_width.__raw = "nil";
          tabs_max_width.__raw = "nil";
          padding = 0;
          separator = {
            left = "▏";
            right = "▕";
          };
          separator_active.__raw = "nil";
          show_separator_on_edge = false;
          highlight_tab = "NeoTreeTabInactive";
          highlight_tab_active = "NeoTreeTabActive";
          highlight_background = "NeoTreeTabInactive";
          highlight_separator = "NeoTreeTabSeparatorInactive";
          highlight_separator_active = "NeoTreeTabSeparatorActive";
        };
        event_handlers = [
          {
            event = "before_render";
            handler = lib.nixvim.mkRaw ''
              function (state)
                -- add something to the state that can be used by custom components
              end
            '';
          }
          {
            event = "file_opened";
            handler = lib.nixvim.mkRaw ''
              function(file_path)
                --auto close
                require("neo-tree").close_all()
              end
            '';
          }
        ];
        default_component_configs = {
          container = {
            enable_character_fade = true;
            width = "100%";
            right_padding = 0;
          };
          diagnostics = {
            symbols = {
              hint = "H";
              info = "I";
              warn = "!";
              error = "X";
            };
            highlights = {
              hint = "DiagnosticSignHint";
              info = "DiagnosticSignInfo";
              warn = "DiagnosticSignWarn";
              error = "DiagnosticSignError";
            };
          };
          indent = {
            indent_size = 2;
            padding = 1;
            with_markers = true;
            indent_marker = "│";
            last_indent_marker = "└";
            highlight = "NeoTreeIndentMarker";
            with_expanders.__raw = "nil";
            expander_collapsed = "";
            expander_expanded = "";
            expander_highlight = "NeoTreeExpander";
          };
          icon = {
            folder_closed = "";
            folder_open = "";
            folder_empty = "ﰊ";
            folder_empty_open = "ﰊ";
            default = "*";
            highlight = "NeoTreeFileIcon";
          };
          modified = {
            symbol = "[+] ";
            highlight = "NeoTreeModified";
          };
          name = {
            trailing_slash = false;
            use_git_status_colors = true;
            highlight = "NeoTreeFileName";
          };
          gitStatus = {
            symbols = {
              added = "✚";
              deleted = "✖";
              modified = "";
              renamed = "";
              untracked = "";
              ignored = "";
              unstaged = "";
              staged = "";
              conflict = "";
            };
            align = "right";
          };
        };
        renderers = {
          directory = [
            "indent"
            "icon"
            "current_filter"
            {
              __unkeyed = "container";
              content = [
                {
                  __unkeyed = "name";
                  zindex = 10;
                }
                {
                  __unkeyed = "clipboard";
                  zindex = 10;
                }
                {
                  __unkeyed = "diagnostics";
                  errors_only = true;
                  zindex = 20;
                  align = "right";
                  hide_when_expanded = true;
                }
                {
                  __unkeyed = "git_status";
                  zindex = 20;
                  align = "right";
                  hide_when_expanded = true;
                }
              ];
            }
          ];
          file = [
            "indent"
            "icon"
            {
              name = "container";
              content = [
                {
                  __unkeyed = "name";
                  zindex = 10;
                }
                {
                  __unkeyed = "clipboard";
                  zindex = 10;
                }
                {
                  __unkeyed = "bufnr";
                  zindex = 10;
                }
                {
                  __unkeyed = "modified";
                  zindex = 20;
                  align = "right";
                }
                {
                  __unkeyed = "diagnostics";
                  zindex = 20;
                  align = "right";
                }
                {
                  __unkeyed = "git_status";
                  zindex = 20;
                  align = "right";
                }
              ];
            }
          ];
          message = [
            {
              __unkeyed = "indent";
              with_markers = false;
            }
            {
              __unkeyed = "name";
              highlight = "NeoTreeMessage";
            }
          ];
          terminal = [
            "indent"
            "icon"
            "name"
            "bufnr"
          ];
        };
        nesting_rules.__empty = { };
        window = {
          position = "left";
          width = 40;
          height = 15;
          auto_expand_width = false;
          popup = {
            size = {
              height = "80%";
              width = "50%";
            };
            position = "80%";
          };
          same_level = false;
          insert_as = "child";
          mapping_options = {
            noremap = true;
            nowait = true;
          };
          mappings = {
            "<space>" = {
              command = "toggle_node";
              # disable `nowait` if you have existing combos starting with this char that you want to use
              nowait = false;
            };
            "<2-LeftMouse>" = "open";
            "<cr>" = "open";
            "<esc>" = "revert_preview";
            P = {
              command = "toggle_preview";
              config = {
                use_float = true;
              };
            };
            l = "focus_preview";
            S = "open_split";
            # S = "split_with_window_picker";
            s = "open_vsplit";
            # s = "vsplit_with_window_picker";
            t = "open_tabnew";
            # "<cr>" = "open_drop";
            # t = "open_tab_drop";
            w = "open_with_window_picker";
            C = "close_node";
            z = "close_all_nodes";
            # Z = "expand_all_nodes";
            R = "refresh";
            a = {
              __unkeyed = "add";
              # some commands may take optional config options, see `:h neo-tree-mappings` for details
              config = {
                show_path = "none"; # "none", "relative", "absolute"
              };
            };
            A = "add_directory"; # also accepts the config.show_path and config.insert_as options.
            d = "delete";
            r = "rename";
            y = "copy_to_clipboard";
            x = "cut_to_clipboard";
            p = "paste_from_clipboard";
            c = "copy"; # takes text input for destination, also accepts the config.show_path and config.insert_as options
            m = "move"; # takes text input for destination, also accepts the config.show_path and config.insert_as options
            e = "toggle_auto_expand_width";
            q = "close_window";
            "?" = "show_help";
            "<" = "prev_source";
            ">" = "next_source";
          };
        };
        filesystem = {
          window = {
            mappings = {
              H = "toggle_hidden";
              "/" = "fuzzy_finder";
              D = "fuzzy_finder_directory";
              # "/" = "filter_as_you_type"; # this was the default until v1.28
              "#" = "fuzzy_sorter"; # fuzzy sorting using the fzy algorithm
              # D = "fuzzy_sorter_directory";
              f = "filter_on_submit";
              "<C-x>" = "clear_filter";
              "<bs>" = "navigate_up";
              "." = "set_root";
              "[g" = "prev_git_modified";
              "]g" = "next_git_modified";
            };
          };
          async_directory_scan = "auto";
          scan_mode = "shallow";
          bind_to_cwd = true;
          cwd_target = {
            sidebar = "tab";
            current = "window";
          };
          filteredItems = {
            visible = false;
            force_visible_in_empty_folder = false;
            showhidden_count = true;
            hide_dotfiles = true;
            hide_gitignored = true;
            hide_hidden = true;
            hide_by_name = [
              ".DS_Store"
              "thumbs.db"
            ];
            hide_by_pattern.__empty = { };
            always_show.__empty = { };
            never_show.__empty = { };
            never_show_by_pattern.__empty = { };
          };
          find_by_full_path_words = false;
          find_command = "fd";
          find_args = {
            fd = [
              "--exclude"
              ".git"
              "--exclude"
              "node_modules"
            ];
          };
          group_empty_dirs = false;
          search_limit = 50;
          follow_current_file = {
            enabled = false;
            leave_dirs_open = false;
          };
          hijack_netrw_behavior = "open_default";
          use_libuv_file_watcher = false;
        };
        buffers = {
          bind_to_cwd = true;
          follow_current_file = {
            enabled = true;
            leave_dirs_open = false;
          };
          group_empty_dirs = true;
          window = {
            mappings = {
              "<bs>" = "navigate_up";
              "." = "set_root";
              bd = "buffer_delete";
            };
          };
        };
        git_status = {
          window = {
            mappings = {
              A = "git_add_all";
              gu = "git_unstage_file";
              ga = "git_add_file";
              gr = "git_revert_file";
              gc = "git_commit";
              gp = "git_push";
              gg = "git_commit_and_push";
            };
          };
        };
        example = {
          renderers = {
            custom = [
              [ "indent" ]
              {
                __unkeyed = "icon";
                default = "C";
              }
              "custom"
              "name"
            ];
          };
          window = {
            mappings = {
              "<cr>" = "toggle_node";
              "<C-e>" = "example_command";
              d = "show_debug_info";
            };
          };
        };
        document_symbols = {
          follow_cursor = false;
          kinds = {
            File = {
              icon = "󰈙";
              hl = "Tag";
            };
            Namespace = {
              icon = "󰌗";
              hl = "Include";
            };
          };
          custom_kinds = {
            "12" = "foo";
            "15" = "bar";
          };
        };
      };
    };
  };

  no-packages = {
    plugins = {
      web-devicons.enable = true;
      neo-tree = {
        enable = true;

        # Otherwise fail at opening the log file
        # ERROR: [Neo-tree WARN] Could not open log file: /build/.local/share/nvim/neo-tree.nvim.log
        # /build/.local/share/nvim/neo-tree.nvim.log: No such file or directory
        settings.log_to_file = false;
      };
    };

    dependencies.git.enable = false;
  };

  no-icons = {
    plugins = {
      web-devicons.enable = false;
      neo-tree = {
        enable = true;

        # Otherwise fail at opening the log file
        # ERROR: [Neo-tree WARN] Could not open log file: /build/.local/share/nvim/neo-tree.nvim.log
        # /build/.local/share/nvim/neo-tree.nvim.log: No such file or directory
        settings.log_to_file = false;
      };
    };
  };
}
