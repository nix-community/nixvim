{
  # Empty configuration
  empty = {
    plugins.nvim-tree.enable = true;
  };

  # All the upstream default options of nvim-tree
  defaults = {
    plugins.nvim-tree = {
      enable = true;

      disableNetrw = true;
      hijackNetrw = false;

      openOnSetup = true;
      openOnSetupFile = true;
      ignoreBufferOnSetup = true;
      ignoreFtOnSetup = ["tex"];
      autoClose = true;

      autoReloadOnWrite = true;
      sortBy = "name";
      hijackUnnamedBufferWhenOpening = false;
      hijackCursor = false;
      rootDirs = [];
      preferStartupRoot = false;
      syncRootWithCwd = false;
      reloadOnBufenter = false;
      respectBufCwd = false;
      hijackDirectories = {
        enable = true;
        autoOpen = true;
      };
      updateFocusedFile = {
        enable = false;
        updateRoot = false;
        ignoreList = [];
      };
      systemOpen = {
        cmd = "";
        args = [];
      };
      diagnostics = {
        enable = false;
        debounceDelay = 50;
        showOnDirs = false;
        showOnOpenDirs = true;
        icons = {
          hint = "";
          info = "";
          warning = "";
          error = "";
        };
        severity = {
          min = "hint";
          max = "error";
        };
      };
      git = {
        enable = true;
        ignore = true;
        showOnDirs = true;
        showOnOpenDirs = true;
        timeout = 400;
      };
      modified = {
        enable = false;
        showOnDirs = true;
        showOnOpenDirs = true;
      };
      filesystemWatchers = {
        enable = true;
        debounceDelay = 50;
        ignoreDirs = [];
      };
      onAttach = "default";
      removeKeymaps = false;
      selectPrompts = false;
      view = {
        centralizeSelection = false;
        cursorline = true;
        debounceDelay = 15;
        hideRootFolder = false;
        width = {
          min = 30;
          max = -1;
          padding = 1;
        };
        side = "left";
        preserveWindowProportions = false;
        number = false;
        relativenumber = false;
        signcolumn = "yes";
        mappings = {
          customOnly = false;
          list = [
            # remove a default mapping for cd
            {
              key = "<2-RightMouse>";
              action = "";
            }

            # add multiple normal mode mappings for edit
            {
              key = ["<CR>" "o"];
              action = "edit";
              mode = "n";
            }

            # custom action
            {
              key = "p";
              action = "print_the_node_path";
              action_cb = ''
                function(node)
                  print(node.absolute_path)
                end
              '';
            }
          ];
        };
        float = {
          enable = false;
          quitOnFocusLoss = true;
          openWinConfig = {
            col = 1;
            row = 1;
            relative = "cursor";
            border = "shadow";
            style = "minimal";
          };
        };
      };
      renderer = {
        addTrailing = false;
        groupEmpty = false;
        fullName = false;
        highlightGit = false;
        highlightOpenedFiles = "none";
        highlightModified = "none";
        rootFolderLabel = ":~:s?$?/..?";
        indentWidth = 2;
        indentMarkers = {
          enable = false;
          inlineArrows = true;
          icons = {
            corner = "└";
            edge = "│";
            item = "│";
            bottom = "─";
            none = " ";
          };
        };
        icons = {
          webdevColors = true;
          gitPlacement = "before";
          modifiedPlacement = "after";
          padding = " ";
          symlinkArrow = " ➛ ";
          show = {
            file = true;
            folder = true;
            folderArrow = true;
            git = true;
            modified = true;
          };
          glyphs = {
            default = "";
            symlink = "";
            modified = "●";
            folder = {
              arrowClosed = "";
              arrowOpen = "";
              default = "";
              open = "";
              empty = "";
              emptyOpen = "";
              symlink = "";
              symlinkOpen = "";
            };
            git = {
              unstaged = "✗";
              staged = "✓";
              unmerged = "";
              renamed = "➜";
              untracked = "★";
              deleted = "";
              ignored = "◌";
            };
          };
        };
        specialFiles = ["Cargo.toml" "Makefile" "README.md" "readme.md"];
        symlinkDestination = true;
      };
      filters = {
        dotfiles = false;
        gitClean = false;
        noBuffer = false;
        custom = [];
        exclude = [];
      };
      actions = {
        changeDir = {
          enable = true;
          global = false;
          restrictAboveCwd = false;
        };
        expandAll = {
          maxFolderDiscovery = 300;
          exclude = [];
        };
        filePopup = {
          openWinConfig = {
            col = 1;
            row = 1;
            relative = "cursor";
            border = "shadow";
            style = "minimal";
          };
        };
        openFile = {
          quitOnOpen = false;
          resizeWindow = true;
        };
        windowPicker = {
          enable = true;
          picker = "default";
          chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
          exclude = {
            filetype = ["notify" "packer" "qf" "diff" "fugitive" "fugitiveblame"];
            buftype = ["nofile" "terminal" "help"];
          };
        };
        removeFile = {
          closeWindow = true;
        };
        useSystemClipboard = true;
      };
      liveFilter = {
        prefix = "[FILTER]: ";
        alwaysShowFolders = true;
      };
      tab = {
        sync = {
          open = false;
          close = false;
          ignore = [];
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
          copyPaste = false;
          dev = false;
          diagnostics = false;
          git = false;
          watcher = false;
        };
      };
    };
  };
}
