{
  empty = {
    plugins.web-devicons.enable = true;
    plugins.neo-tree.enable = true;
  };

  defaults = {
    plugins.web-devicons.enable = true;
    plugins.neo-tree = {
      enable = true;

      sources = [
        "filesystem"
        "buffers"
        "git_status"
      ];

      addBlankLineAtTop = false;
      autoCleanAfterSessionRestore = false;
      closeIfLastWindow = false;
      defaultSource = "filesystem";
      enableDiagnostics = true;
      enableGitStatus = true;
      enableModifiedMarkers = true;
      enableRefreshOnWrite = true;
      gitStatusAsync = true;
      gitStatusAsyncOptions = {
        batchSize = 1000;
        batchDelay = 10;
        maxLines = 10000;
      };
      hideRootNode = false;
      retainHiddenRootIndent = false;
      logLevel = "info";
      logToFile = false;
      openFilesInLastWindow = true;
      popupBorderStyle = "NC";
      resizeTimerInterval = 500;
      sortCaseInsensitive = false;
      sortFunction = "nil";
      usePopupsForInput = true;
      useDefaultMappings = true;
      sourceSelector = {
        winbar = false;
        statusline = false;
        showScrolledOffParentNode = false;
        sources = [
          {
            source = "filesystem";
            displayName = "  Files ";
          }
          {
            source = "buffers";
            displayName = "  Buffers ";
          }
          {
            source = "gitStatus";
            displayName = "  Git ";
          }
          {
            source = "diagnostics";
            displayName = " 裂Diagnostics ";
          }
        ];
        contentLayout = "start";
        tabsLayout = "equal";
        truncationCharacter = "…";
        tabsMinWidth = null;
        tabsMaxWidth = null;
        padding = 0;
        separator = {
          left = "▏";
          right = "▕";
        };
        separatorActive = null;
        showSeparatorOnEdge = false;
        highlightTab = "NeoTreeTabInactive";
        highlightTabActive = "NeoTreeTabActive";
        highlightBackground = "NeoTreeTabInactive";
        highlightSeparator = "NeoTreeTabSeparatorInactive";
        highlightSeparatorActive = "NeoTreeTabSeparatorActive";
      };
      eventHandlers = {
        before_render = ''
          function (state)
            -- add something to the state that can be used by custom components
          end
        '';

        file_opened = ''
          function(file_path)
            --auto close
            require("neo-tree").close_all()
          end
        '';
      };
      defaultComponentConfigs = {
        container = {
          enableCharacterFade = true;
          width = "100%";
          rightPadding = 0;
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
          indentSize = 2;
          padding = 1;
          withMarkers = true;
          indentMarker = "│";
          lastIndentMarker = "└";
          highlight = "NeoTreeIndentMarker";
          withExpanders = null;
          expanderCollapsed = "";
          expanderExpanded = "";
          expanderHighlight = "NeoTreeExpander";
        };
        icon = {
          folderClosed = "";
          folderOpen = "";
          folderEmpty = "ﰊ";
          folderEmptyOpen = "ﰊ";
          default = "*";
          highlight = "NeoTreeFileIcon";
        };
        modified = {
          symbol = "[+] ";
          highlight = "NeoTreeModified";
        };
        name = {
          trailingSlash = false;
          useGitStatusColors = true;
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
            name = "container";
            content = [
              {
                name = "name";
                zindex = 10;
              }
              {
                name = "clipboard";
                zindex = 10;
              }
              {
                name = "diagnostics";
                errors_only = true;
                zindex = 20;
                align = "right";
                hide_when_expanded = true;
              }
              {
                name = "git_status";
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
                name = "name";
                zindex = 10;
              }
              {
                name = "clipboard";
                zindex = 10;
              }
              {
                name = "bufnr";
                zindex = 10;
              }
              {
                name = "modified";
                zindex = 20;
                align = "right";
              }
              {
                name = "diagnostics";
                zindex = 20;
                align = "right";
              }
              {
                name = "git_status";
                zindex = 20;
                align = "right";
              }
            ];
          }
        ];
        message = [
          {
            name = "indent";
            with_markers = false;
          }
          {
            name = "name";
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
      nestingRules = { };
      window = {
        position = "left";
        width = 40;
        height = 15;
        autoExpandWidth = false;
        popup = {
          size = {
            height = "80%";
            width = "50%";
          };
          position = "80%";
        };
        sameLevel = false;
        insertAs = "child";
        mappingOptions = {
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
            command = "add";
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
        asyncDirectoryScan = "auto";
        scanMode = "shallow";
        bindToCwd = true;
        cwdTarget = {
          sidebar = "tab";
          current = "window";
        };
        filteredItems = {
          visible = false;
          forceVisibleInEmptyFolder = false;
          showHiddenCount = true;
          hideDotfiles = true;
          hideGitignored = true;
          hideHidden = true;
          hideByName = [
            ".DS_Store"
            "thumbs.db"
          ];
          hideByPattern = [ ];
          alwaysShow = [ ];
          neverShow = [ ];
          neverShowByPattern = [ ];
        };
        findByFullPathWords = false;
        findCommand = "fd";
        findArgs = {
          fd = [
            "--exclude"
            ".git"
            "--exclude"
            "node_modules"
          ];
        };
        groupEmptyDirs = false;
        searchLimit = 50;
        followCurrentFile = {
          enabled = false;
          leaveDirsOpen = false;
        };
        hijackNetrwBehavior = "open_default";
        useLibuvFileWatcher = false;
      };
      buffers = {
        bindToCwd = true;
        followCurrentFile = {
          enabled = true;
          leaveDirsOpen = false;
        };
        groupEmptyDirs = true;
        window = {
          mappings = {
            "<bs>" = "navigate_up";
            "." = "set_root";
            bd = "buffer_delete";
          };
        };
      };
      gitStatus = {
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
            "indent"
            {
              name = "icon";
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
      documentSymbols = {
        followCursor = false;
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
        customKinds = {
          "12" = "foo";
          "15" = "bar";
        };
      };
    };
  };

  no-packages = {
    plugins.web-devicons.enable = false;
    plugins.neo-tree = {
      enable = true;
      gitPackage = null;
    };
  };

  no-icons = {
    plugins = {
      web-devicons.enable = false;
      neo-tree.enable = true;
    };
  };
}
