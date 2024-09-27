{
  lib,
  helpers,
  pkgs,
  config,
  options,
  ...
}:
with lib;
let
  cfg = config.plugins.nvim-tree;

  openWinConfigOption =
    helpers.defaultNullOpts.mkAttributeSet
      # Default
      {
        col = 1;
        row = 1;
        relative = "cursor";
        border = "shadow";
        style = "minimal";
      }
      # Description
      ''
        Floating window config for file_popup. See |nvim_open_win| for more details.
        You shouldn't define `"width"` and `"height"` values here.
        They will be overridden to fit the file_popup content.
      '';
in
{
  imports = [
    (mkRemovedOptionModule [
      "plugins"
      "nvim-tree"
      "view"
      "hideRootFolder"
    ] "Set `plugins.nvim-tree.renderer.rootFolderLabel` to `false` to hide the root folder.")
  ];
  options.plugins.nvim-tree = helpers.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "nvim-tree";

    package = lib.mkPackageOption pkgs "nvim-tree" {
      default = [
        "vimPlugins"
        "nvim-tree-lua"
      ];
    };

    gitPackage = lib.mkPackageOption pkgs "git" {
      nullable = true;
    };

    disableNetrw = helpers.defaultNullOpts.mkBool false "Disable netrw";

    hijackNetrw = helpers.defaultNullOpts.mkBool true "Hijack netrw";

    openOnSetup = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Will automatically open the tree when running setup if startup buffer is a directory, is
        empty or is unnamed. nvim-tree window will be focused.
      '';
    };

    openOnSetupFile = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Will automatically open the tree when running setup if startup buffer is a file.
        File window will be focused.
        File will be found if updateFocusedFile is enabled.
      '';
    };

    ignoreBufferOnSetup = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Will ignore the buffer, when deciding to open the tree on setup.
      '';
    };

    ignoreFtOnSetup = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        List of filetypes that will prevent `open_on_setup` to open.
        You can use this option if you don't want the tree to open
        in some scenarios (eg using vim startify).
      '';
    };

    autoClose = mkOption {
      type = types.bool;
      default = false;
      description = "Automatically close";
    };

    autoReloadOnWrite = helpers.defaultNullOpts.mkBool true ''
      Reloads the explorer every time a buffer is written to.
    '';

    sortBy =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "name"
          "case_sensitive"
          "modification_time"
          "extension"
        ]
        ''
          Changes how files within the same directory are sorted.
          Can be one of `name`, `case_sensitive`, `modification_time`, `extension` or a
          function.
            Type: `string` | `function(nodes)`, Default: `"name"`

            Function is passed a table of nodes to be sorted, each node containing:
            - `absolute_path`: `string`
            - `executable`:    `boolean`
            - `extension`:     `string`
            - `link_to`:       `string`
            - `name`:          `string`
            - `type`:          `"directory"` | `"file"` | `"link"`

            Example: sort by name length:
              sortBy = {
                __raw = \'\'
                  local sort_by = function(nodes)
                    table.sort(nodes, function(a, b)
                      return #a.name < #b.name
                    end)
                  end
                \'\';
              };
        '';

    hijackUnnamedBufferWhenOpening = helpers.defaultNullOpts.mkBool false ''
      Opens in place of the unnamed buffer if it's empty.
    '';

    hijackCursor = helpers.defaultNullOpts.mkBool false ''
      Keeps the cursor on the first letter of the filename when moving in the tree.
    '';

    rootDirs = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Preferred root directories.
      Only relevant when `updateFocusedFile.updateRoot` is `true`.
    '';

    preferStartupRoot = helpers.defaultNullOpts.mkBool false ''
      Prefer startup root directory when updating root directory of the tree.
      Only relevant when `updateFocusedFile.updateRoot` is `true`
    '';

    syncRootWithCwd = helpers.defaultNullOpts.mkBool false ''
      Changes the tree root directory on `DirChanged` and refreshes the tree.
    '';

    reloadOnBufenter = helpers.defaultNullOpts.mkBool false ''
      Automatically reloads the tree on `BufEnter` nvim-tree.
    '';

    respectBufCwd = helpers.defaultNullOpts.mkBool false ''
      Will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
    '';

    hijackDirectories = {
      enable = helpers.defaultNullOpts.mkBool true ''
        Hijacks new directory buffers when they are opened (`:e dir`).

        Disable this option if you use vim-dirvish or dirbuf.nvim.
        If `hijackNetrw` and `disableNetrw` are `false`, this feature will be disabled.
      '';

      autoOpen = helpers.defaultNullOpts.mkBool true ''
        Opens the tree if the tree was previously closed.
      '';
    };

    updateFocusedFile = {
      enable = helpers.defaultNullOpts.mkBool false ''
        Update the focused file on `BufEnter`, un-collapses the folders recursively until it finds
        the file.
      '';

      updateRoot = helpers.defaultNullOpts.mkBool false ''
        Update the root directory of the tree if the file is not under current root directory.
        It prefers vim's cwd and `root_dirs`.
        Otherwise it falls back to the folder containing the file.
        Only relevant when `updateFocusedFile.enable` is `true`
      '';

      ignoreList = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        List of buffer names and filetypes that will not update the root dir of the tree if the
        file isn't found under the current root directory.
        Only relevant when `updateFocusedFile.updateRoot` and `updateFocusedFile.enable` are
        `true`.
      '';
    };

    systemOpen = {
      cmd = helpers.defaultNullOpts.mkStr "" ''
        The open command itself.

        Leave empty for OS specific default:
          UNIX:    `"xdg-open"`
          macOS:   `"open"`
          Windows: "`cmd"`
      '';

      args = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        Optional argument list.

        Leave empty for OS specific default:
          Windows: `{ "/c", "start", '""' }`
      '';
    };

    diagnostics = {
      enable = helpers.defaultNullOpts.mkBool false ''
        Show LSP and COC diagnostics in the signcolumn
        Note that the modified sign will take precedence over the diagnostics signs.

        `NOTE`: it will use the default diagnostic color groups to highlight the signs.
        If you wish to customize, you can override these groups:
        - `NvimTreeLspDiagnosticsError`
        - `NvimTreeLspDiagnosticsWarning`
        - `NvimTreeLspDiagnosticsInformation`
        - `NvimTreeLspDiagnosticsHint`
      '';

      debounceDelay = helpers.defaultNullOpts.mkInt 50 ''
        Idle milliseconds between diagnostic event and update.
      '';

      showOnDirs = helpers.defaultNullOpts.mkBool false ''
        Show diagnostic icons on parent directories.
      '';

      showOnOpenDirs = helpers.defaultNullOpts.mkBool true ''
        Show diagnostics icons on directories that are open.
        Only relevant when `diagnostics.showOnDirs` is `true
      '';

      icons = {
        hint = helpers.defaultNullOpts.mkStr "" "";
        info = helpers.defaultNullOpts.mkStr "" "";
        warning = helpers.defaultNullOpts.mkStr "" "";
        error = helpers.defaultNullOpts.mkStr "" "";
      };

      severity = {
        min = helpers.defaultNullOpts.mkSeverity "hint" ''
          Minimum severity for which the diagnostics will be displayed.
          See `|diagnostic-severity|`.
        '';
        max = helpers.defaultNullOpts.mkSeverity "error" ''
          Maximum severity for which the diagnostics will be displayed.
          See `|diagnostic-severity|`.
        '';
      };
    };

    git = {
      enable = helpers.defaultNullOpts.mkBool true ''
        Git integration with icons and colors.
      '';

      ignore = helpers.defaultNullOpts.mkBool true ''
        Ignore files based on `.gitignore`. Requires `git.enable` to be `true`.
        Toggle via the `toggle_git_ignored` action, default mapping `I`.
      '';

      showOnDirs = helpers.defaultNullOpts.mkBool true ''
        Show status icons of children when directory itself has no status icon.
      '';

      showOnOpenDirs = helpers.defaultNullOpts.mkBool true ''
        Show status icons of children on directories that are open.
        Only relevant when `git.showOnDirs` is `true`.
      '';

      timeout = helpers.defaultNullOpts.mkInt 400 ''
        Kills the git process after some time if it takes too long.
      '';
    };

    modified = {
      enable = helpers.defaultNullOpts.mkBool false ''
        Indicate which file have unsaved modification.
      '';

      showOnDirs = helpers.defaultNullOpts.mkBool true ''
        Show modified indication on directory whose children are modified.
      '';

      showOnOpenDirs = helpers.defaultNullOpts.mkBool true ''
        Show modified indication on open directories.
        Only relevant when `modified.showOnDirs` is `true`.
      '';
    };

    filesystemWatchers = {
      enable = helpers.defaultNullOpts.mkBool true ''
        Will use file system watcher (libuv fs_event) to watch the filesystem for changes.
        Using this will disable BufEnter / BufWritePost events in nvim-tree which were used to
        update the whole tree.
        With this feature, the tree will be updated only for the appropriate folder change,
        resulting in better performance.
      '';

      debounceDelay = helpers.defaultNullOpts.mkInt 50 ''
        Idle milliseconds between filesystem change and action.
      '';

      ignoreDirs = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        List of vim regex for absolute directory paths that will not be watched.
        Backslashes must be escaped e.g. `"my-project/\\.build$"`.
        See |string-match|.
        Useful when path is not in `.gitignore` or git integration is disabled.
      '';
    };

    onAttach =
      helpers.defaultNullOpts.mkNullable (with types; either (enum [ "default" ]) rawLua) "default"
        ''
          Function ran when creating the nvim-tree buffer.
          This can be used to attach keybindings to the tree buffer.
          When onAttach is "default", it will use the older mapping strategy, otherwise it
          will use the newer one.

          Example:
          {
            __raw = \'\'
              function(bufnr)
                local api = require("nvim-tree.api")
                vim.keymap.set("n", "<C-P>", function()
                  local node = api.tree.get_node_under_cursor()
                  print(node.absolute_path)
                end, { buffer = bufnr, noremap = true, silent = true, nowait = true, desc = "print the node's absolute path" })
              end
            \'\';
          }
        '';

    selectPrompts = helpers.defaultNullOpts.mkBool false ''
      Use |vim.ui.select| style prompts.
      Necessary when using a UI prompt decorator such as dressing.nvim or telescope-ui-select.nvim.
    '';

    view = {
      centralizeSelection = helpers.defaultNullOpts.mkBool false ''
        When entering nvim-tree, reposition the view so that the current node is
        initially centralized, see |zz|.
      '';

      cursorline = helpers.defaultNullOpts.mkBool true ''
        Enable |cursorline| in the tree window.
      '';

      debounceDelay = helpers.defaultNullOpts.mkInt 15 ''
        Idle milliseconds before some reload / refresh operations.
        Increase if you experience performance issues around screen refresh.
      '';

      width =
        helpers.defaultNullOpts.mkNullable
          (
            with types;
            oneOf [
              str
              int
              (submodule {
                options =
                  let
                    strOrInt = either str int;
                  in
                  {
                    # TODO check type
                    min = helpers.defaultNullOpts.mkNullable strOrInt "30" "Minimum dynamic width.";

                    max = helpers.defaultNullOpts.mkNullable strOrInt "-1" ''
                      Maximum dynamic width, -1 for unbounded.
                    '';

                    padding =
                      helpers.defaultNullOpts.mkNullable (either ints.unsigned rawLua) "1"
                        "Extra padding to the right.";
                  };
              })
            ]
          )
          30
          ''
            Width of the window: can be a `%` string, a number representing columns or a table.
            A table indicates that the view should be dynamically sized based on the longest line.
          '';

      side =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "left"
            "right"
          ]
          ''
            Side of the tree, can be `"left"`, `"right"`.
          '';

      preserveWindowProportions = helpers.defaultNullOpts.mkBool false ''
        Preserves window proportions when opening a file.
        If `false`, the height and width of windows other than nvim-tree will be equalized.
      '';

      number = helpers.defaultNullOpts.mkBool false ''
        Print the line number in front of each line.
      '';

      relativenumber = helpers.defaultNullOpts.mkBool false ''
        Show the line number relative to the line with the cursor in front of each line.
        If the option `view.number` is also `true`, the number on the cursor line
        will be the line number instead of `0`.
      '';

      signcolumn =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "yes"
            "auto"
            "no"
          ]
          ''
            Show diagnostic sign column. Value can be `"yes"`, `"auto"`, `"no"`.
          '';

      float = {
        enable = helpers.defaultNullOpts.mkBool false ''
          Tree window will be floating.
        '';

        quitOnFocusLoss = helpers.defaultNullOpts.mkBool true ''
          Close the floating tree window when it loses focus.
        '';

        openWinConfig = openWinConfigOption;
      };
    };

    renderer = {
      addTrailing = helpers.defaultNullOpts.mkBool false ''
        Appends a trailing slash to folder names.
      '';

      groupEmpty = helpers.defaultNullOpts.mkBool false ''
        Compact folders that only contain a single folder into one node in the file tree.
      '';

      fullName = helpers.defaultNullOpts.mkBool false ''
        Display node whose name length is wider than the width of nvim-tree window in floating window.
      '';

      highlightGit = helpers.defaultNullOpts.mkBool false ''
        Enable file highlight for git attributes using `NvimTreeGit*` highlight groups.
        Requires `nvim-tree.git.enable`
        This can be used with or without the icons.
      '';

      highlightOpenedFiles =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "none"
            "icon"
            "name"
            "all"
          ]
          ''
            Highlight icons and/or names for opened files using the `NvimTreeOpenedFile` highlight
            group.
          '';

      highlightModified =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "none"
            "icon"
            "name"
            "all"
          ]
          ''
            Highlight icons and/or names for modified files using the `NvimTreeModified` highlight
            group.
            Requires `nvim-tree.modified.enable`
            This can be used with or without the icons.
          '';

      rootFolderLabel =
        helpers.defaultNullOpts.mkNullable
          # Type
          (
            with types;
            oneOf [
              str
              bool
              rawLua
            ]
          )
          # Default
          ":~:s?$?/..?"
          # Description
          ''
            In what format to show root folder. See `:help filename-modifiers` for available `string`
            options.

            Set to `false` to hide the root folder.

            This can also be a `function(root_cwd)` which is passed the absolute path of the root folder
            and should return a string.
            e.g.

            rootFolderLabel = {
              __raw = \'\'
                  my_root_folder_label = function(path)
                  return ".../" .. vim.fn.fnamemodify(path, ":t")
                  end
              \'\';
            };
          '';

      indentWidth = helpers.defaultNullOpts.mkInt 2 ''
        Number of spaces for an each tree nesting level. Minimum 1.
      '';

      indentMarkers = {
        enable = helpers.defaultNullOpts.mkBool false ''
          Display indent markers when folders are open
        '';

        inlineArrows = helpers.defaultNullOpts.mkBool true ''
          Display folder arrows in the same column as indent marker when using
          |renderer.icons.show.folder_arrow|.
        '';

        icons = {
          corner = helpers.defaultNullOpts.mkStr "└" "";
          edge = helpers.defaultNullOpts.mkStr "│" "";
          item = helpers.defaultNullOpts.mkStr "│" "";
          bottom = helpers.defaultNullOpts.mkStr "─" "";
          none = helpers.defaultNullOpts.mkStr " " "";
        };
      };

      icons = {
        webdevColors = helpers.defaultNullOpts.mkBool true ''
          Use the webdev icon colors, otherwise `NvimTreeFileIcon`.
        '';

        gitPlacement =
          helpers.defaultNullOpts.mkEnum
            [
              "after"
              "before"
              "signcolumn"
            ]
            "before"
            ''
              Place where the git icons will be rendered.
              Can be `"after"` or `"before"` filename (after the file/folders icons) or `"signcolumn"`
              (requires |nvim-tree.view.signcolumn| enabled).
              Note that the diagnostic signs and the modified sign will take precedence over the git
              signs.
            '';

        modifiedPlacement =
          helpers.defaultNullOpts.mkEnumFirstDefault
            [
              "after"
              "before"
              "signcolumn"
            ]
            ''
              Place where the modified icon will be rendered.
              Can be `"after"` or `"before"` filename (after the file/folders icons) or `"signcolumn"`
              (requires |nvim-tree.view.signcolumn| enabled).
            '';

        padding = helpers.defaultNullOpts.mkStr " " ''
          Inserted between icon and filename.
        '';

        symlinkArrow = helpers.defaultNullOpts.mkStr " ➛ " ''
          Used as a separator between symlinks' source and target.
        '';

        show = {
          file = helpers.defaultNullOpts.mkBool true ''
            Show an icon before the file name. `nvim-web-devicons` will be used if available.
          '';

          folder = helpers.defaultNullOpts.mkBool true ''
            Show an icon before the folder name.
          '';

          folderArrow = helpers.defaultNullOpts.mkBool true ''
            Show a small arrow before the folder node.
            Arrow will be a part of the node when using |renderer.indent_markers|.
          '';

          git = helpers.defaultNullOpts.mkBool true ''
            Show a git status icon, see |renderer.icons.git_placement|
            Requires `git.enable = true`
          '';

          modified = helpers.defaultNullOpts.mkBool true ''
            Show a modified icon, see |renderer.icons.modified_placement|
            Requires |modified.enable| `= true`
          '';
        };

        glyphs = {
          default = helpers.defaultNullOpts.mkStr "" ''
            Glyph for files. Will be overridden by `nvim-web-devicons` if available.
          '';

          symlink = helpers.defaultNullOpts.mkStr "" ''
            Glyph for symlinks to files.
          '';

          modified = helpers.defaultNullOpts.mkStr "●" ''
            Icon to display for modified files.
          '';

          folder = {
            arrowClosed = helpers.defaultNullOpts.mkStr "" ''
              Arrow glyphs for closed directories.
            '';
            arrowOpen = helpers.defaultNullOpts.mkStr "" ''
              Arrow glyphs for open directories.
            '';
            default = helpers.defaultNullOpts.mkStr "" ''
              Default glyph for directories.
            '';
            open = helpers.defaultNullOpts.mkStr "" ''
              Glyph for open directories.
            '';
            empty = helpers.defaultNullOpts.mkStr "" ''
              Glyph for empty directories.
            '';
            emptyOpen = helpers.defaultNullOpts.mkStr "" ''
              Glyph for open empty directories.
            '';
            symlink = helpers.defaultNullOpts.mkStr "" ''
              Glyph for symlink directories.
            '';
            symlinkOpen = helpers.defaultNullOpts.mkStr "" ''
              Glyph for open symlink directories.
            '';
          };

          git = {
            unstaged = helpers.defaultNullOpts.mkStr "✗" ''
              Glyph for unstaged nodes.
            '';
            staged = helpers.defaultNullOpts.mkStr "✓" ''
              Glyph for staged nodes.
            '';
            unmerged = helpers.defaultNullOpts.mkStr "" ''
              Glyph for unmerged nodes.
            '';
            renamed = helpers.defaultNullOpts.mkStr "➜" ''
              Glyph for renamed nodes.
            '';
            untracked = helpers.defaultNullOpts.mkStr "★" ''
              Glyph for untracked nodes.
            '';
            deleted = helpers.defaultNullOpts.mkStr "" ''
              Glyph for deleted nodes.
            '';
            ignored = helpers.defaultNullOpts.mkStr "◌" ''
              Glyph for deleted nodes.
            '';
          };
        };
      };

      specialFiles = helpers.defaultNullOpts.mkListOf types.str [
        "Cargo.toml"
        "Makefile"
        "README.md"
        "readme.md"
      ] "A list of filenames that gets highlighted with `NvimTreeSpecialFile`.";

      symlinkDestination = helpers.defaultNullOpts.mkBool true ''
        Whether to show the destination of the symlink.
      '';
    };

    filters = {
      dotfiles = helpers.defaultNullOpts.mkBool false ''
        Do not show dotfiles: files starting with a `.`
        Toggle via the `toggle_dotfiles` action, default mapping `H`.
      '';

      gitClean = helpers.defaultNullOpts.mkBool false ''
        Do not show files with no git status. This will show ignored files when
        |nvim-tree.git.ignore| is set, as they are effectively dirty.
        Toggle via the `toggle_git_clean` action, default mapping `C`.
      '';

      noBuffer = helpers.defaultNullOpts.mkBool false ''
        Do not show files that have no listed buffer.
        Toggle via the `toggle_no_buffer` action, default mapping `B`.
        For performance reasons this may not immediately update on buffer delete/wipe.
        A reload or filesystem event will result in an update.
      '';

      custom = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        Custom list of vim regex for file/directory names that will not be shown.
        Backslashes must be escaped e.g. "^\\.git". See |string-match|.
        Toggle via the `toggle_custom` action, default mapping `U`.
      '';

      exclude = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        List of directories or files to exclude from filtering: always show them.
        Overrides `git.ignore`, `filters.dotfiles` and `filters.custom`.
      '';
    };

    trash = {
      cmd = helpers.defaultNullOpts.mkStr "gio trash" ''
        The command used to trash items (must be installed on your system).
        The default is shipped with glib2 which is a common linux package.
        Only available for UNIX.
      '';
    };

    actions = {
      changeDir = {
        enable = helpers.defaultNullOpts.mkBool true ''
          Change the working directory when changing directories in the tree.
        '';

        global = helpers.defaultNullOpts.mkBool false ''
          Use `:cd` instead of `:lcd` when changing directories.
          Consider that this might cause issues with the |nvim-tree.sync_root_with_cwd| option.
        '';

        restrictAboveCwd = helpers.defaultNullOpts.mkBool false ''
          Restrict changing to a directory above the global current working directory.
        '';
      };

      expandAll = {
        maxFolderDiscovery = helpers.defaultNullOpts.mkInt 300 ''
          Limit the number of folders being explored when expanding every folders.
          Avoids hanging neovim when running this action on very large folders.
        '';

        exclude = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          A list of directories that should not be expanded automatically.
          E.g `[ ".git" "target" "build" ]` etc.
        '';
      };

      filePopup = {
        openWinConfig = openWinConfigOption;
      };

      openFile = {
        quitOnOpen = helpers.defaultNullOpts.mkBool false ''
          Closes the explorer when opening a file.
          It will also disable preventing a buffer overriding the tree.
        '';

        resizeWindow = helpers.defaultNullOpts.mkBool true ''
          Resizes the tree when opening a file.
        '';
      };

      windowPicker = {
        enable = helpers.defaultNullOpts.mkBool true ''
          Enable the window picker.
          If the feature is not enabled, files will open in window from which you last opened the
          tree.
        '';

        picker = helpers.defaultNullOpts.mkStr' {
          pluginDefault = "default";
          description = ''
            Change the default window picker. This can either be a string or a function (see example).

            The function should return the window id that will open the node, or `nil` if an
            invalid window is picked or user cancelled the action.
          '';
          example.__raw = "require('window-picker').pick_window";
        };

        chars = helpers.defaultNullOpts.mkStr "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" ''
          A string of chars used as identifiers by the window picker.
        '';

        exclude =
          helpers.defaultNullOpts.mkAttrsOf (with types; listOf str)
            {
              filetype = [
                "notify"
                "lazy"
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
            }
            ''
              Table of buffer option names mapped to a list of option values that indicates to
              the picker that the buffer's window should not be selectable.
            '';
      };

      removeFile = {
        closeWindow = helpers.defaultNullOpts.mkBool true ''
          Close any window displaying a file when removing the file from the tree.
        '';
      };

      useSystemClipboard = helpers.defaultNullOpts.mkBool true ''
        A boolean value that toggle the use of system clipboard when copy/paste function are
        invoked.
        When enabled, copied text will be stored in registers '+' (system), otherwise, it will be
        stored in '1' and '"'.
      '';
    };

    liveFilter = {
      prefix = helpers.defaultNullOpts.mkStr "[FILTER]: " ''
        Prefix of the filter displayed in the buffer.
      '';

      alwaysShowFolders = helpers.defaultNullOpts.mkBool true ''
        Whether to filter folders or not.
      '';
    };

    tab = {
      sync = {
        open = helpers.defaultNullOpts.mkBool false ''
          Opens the tree automatically when switching tabpage or opening a new tabpage if the tree
          was previously open.
        '';

        close = helpers.defaultNullOpts.mkBool false ''
          Closes the tree across all tabpages when the tree is closed.
        '';

        ignore = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          List of filetypes or buffer names on new tab that will prevent
          |nvim-tree.tab.sync.open| and |nvim-tree.tab.sync.close|
        '';
      };
    };

    notify = {
      threshold = helpers.defaultNullOpts.mkLogLevel "info" ''
        Specify minimum notification level, uses the values from |vim.log.levels|

        - `error`:   hard errors e.g. failure to read from the file system.
        - `warning`: non-fatal errors e.g. unable to system open a file.
        - `info:`    information only e.g. file copy path confirmation.
        - `debug:`   not used.
      '';
    };

    ui = {
      confirm = {
        remove = helpers.defaultNullOpts.mkBool true ''
          Prompt before removing.
        '';

        trash = helpers.defaultNullOpts.mkBool true ''
          Prompt before trashing.
        '';
      };
    };

    log = {
      enable = helpers.defaultNullOpts.mkBool false ''
        Enable logging to a file `$XDG_CACHE_HOME/nvim/nvim-tree.log`
      '';

      truncate = helpers.defaultNullOpts.mkBool false ''
        Remove existing log file at startup.
      '';

      types = {
        all = helpers.defaultNullOpts.mkBool false "Everything.";

        profile = helpers.defaultNullOpts.mkBool false "Timing of some operations.";

        config = helpers.defaultNullOpts.mkBool false "Options and mappings, at startup.";

        copyPaste = helpers.defaultNullOpts.mkBool false "File copy and paste actions.";

        dev = helpers.defaultNullOpts.mkBool false ''
          Used for local development only. Not useful for users.
        '';

        diagnostics = helpers.defaultNullOpts.mkBool false "LSP and COC processing, verbose.";

        git = helpers.defaultNullOpts.mkBool false "Git processing, verbose.";

        watcher = helpers.defaultNullOpts.mkBool false ''
          |nvim-tree.filesystem_watchers| processing, verbose.
        '';
      };
    };
  };

  config =
    let
      setupOptions =
        with cfg;
        {
          disable_netrw = disableNetrw;
          hijack_netrw = hijackNetrw;
          auto_reload_on_write = autoReloadOnWrite;
          sort_by = sortBy;
          hijack_unnamed_buffer_when_opening = hijackUnnamedBufferWhenOpening;
          hijack_cursor = hijackCursor;
          root_dirs = rootDirs;
          prefer_startup_root = preferStartupRoot;
          sync_root_with_cwd = syncRootWithCwd;
          reload_on_bufenter = reloadOnBufenter;
          respect_buf_cwd = respectBufCwd;
          hijack_directories = with hijackDirectories; {
            inherit enable;
            auto_open = autoOpenEnabled;
          };
          update_focused_file = with updateFocusedFile; {
            inherit enable;
            update_root = updateRoot;
            ignore_list = ignoreList;
          };
          system_open = systemOpen;
          diagnostics = with diagnostics; {
            inherit enable;
            debounce_delay = debounceDelay;
            show_on_dirs = showOnDirs;
            show_on_open_dirs = showOnOpenDirs;
            inherit icons;
            severity = with severity; {
              inherit min max;
            };
          };
          git = with git; {
            inherit enable;
            inherit ignore;
            show_on_dirs = showOnDirs;
            show_on_open_dirs = showOnOpenDirs;
            inherit timeout;
          };
          modified = with modified; {
            inherit enable;
            show_on_dirs = showOnDirs;
            show_on_open_dirs = showOnOpenDirs;
          };
          filesystem_watchers = with filesystemWatchers; {
            inherit enable;
            debounce_delay = debounceDelay;
            ignore_dirs = ignoreDirs;
          };
          on_attach = onAttach;
          select_prompts = selectPrompts;
          view = with view; {
            centralize_selection = centralizeSelection;
            inherit cursorline;
            debounce_delay = debounceDelay;
            inherit width;
            inherit side;
            preserve_window_proportions = preserveWindowProportions;
            inherit number;
            inherit relativenumber;
            inherit signcolumn;
            float = with float; {
              inherit enable;
              quit_on_focus_loss = quitOnFocusLoss;
              open_win_config = openWinConfig;
            };
          };
          renderer = with renderer; {
            add_trailing = addTrailing;
            group_empty = groupEmpty;
            full_name = fullName;
            highlight_git = highlightGit;
            highlight_opened_files = highlightOpenedFiles;
            highlight_modified = highlightModified;
            root_folder_label = rootFolderLabel;
            indent_width = indentWidth;
            indent_markers = with indentMarkers; {
              inherit enable icons;
              inline_arrows = inlineArrows;
            };
            icons = with icons; {
              webdev_colors = webdevColors;
              git_placement = gitPlacement;
              modified_placement = modifiedPlacement;
              inherit padding;
              symlink_arrow = symlinkArrow;
              show = with show; {
                inherit
                  file
                  folder
                  git
                  modified
                  ;
                folder_arrow = folderArrow;
              };
              glyphs = with glyphs; {
                inherit
                  default
                  symlink
                  modified
                  git
                  ;
                folder = with folder; {
                  arrow_closed = arrowClosed;
                  arrow_open = arrowOpen;
                  inherit
                    default
                    open
                    empty
                    symlink
                    ;
                  empty_open = emptyOpen;
                  symlink_open = symlinkOpen;
                };
              };
            };
            special_files = specialFiles;
            symlink_destination = symlinkDestination;
          };
          filters = with filters; {
            inherit dotfiles custom exclude;
            git_clean = gitClean;
            no_buffer = noBuffer;
          };
          inherit trash;
          actions = with actions; {
            change_dir = with changeDir; {
              inherit enable global;
              restrict_above_cwd = restrictAboveCwd;
            };
            expand_all = with expandAll; {
              max_folder_discovery = maxFolderDiscovery;
              inherit exclude;
            };
            file_popup = with filePopup; {
              open_win_config = openWinConfig;
            };
            open_file = with openFile; {
              quit_on_open = quitOnOpen;
              resize_window = resizeWindow;
              window_picker = windowPicker;
            };
            remove_file = with removeFile; {
              close_window = closeWindow;
            };
            use_system_clipboard = useSystemClipboard;
          };
          live_filter = with liveFilter; {
            inherit prefix;
            always_show_folders = alwaysShowFolders;
          };
          inherit tab;
          notify = with notify; {
            inherit threshold;
          };
          inherit ui;
          log = with log; {
            inherit enable truncate;
            types = with log.types; {
              inherit
                all
                profile
                dev
                diagnostics
                git
                watcher
                ;
              inherit (log.types) config;
              copy_paste = copyPaste;
            };
          };
        }
        // cfg.extraOptions;

      autoOpenEnabled = cfg.openOnSetup or cfg.openOnSetupFile;

      openNvimTreeFunction = ''
        local function open_nvim_tree(data)

          ------------------------------------------------------------------------------------------

          -- buffer is a directory
          local directory = vim.fn.isdirectory(data.file) == 1

          -- buffer is a [No Name]
          local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

          -- Will automatically open the tree when running setup if startup buffer is a directory,
          -- is empty or is unnamed. nvim-tree window will be focused.
          local open_on_setup = ${helpers.toLuaObject cfg.openOnSetup}

          if (directory or no_name) and open_on_setup then
            -- change to the directory
            if directory then
              vim.cmd.cd(data.file)
            end

            -- open the tree
            require("nvim-tree.api").tree.open()
            return
          end

          ------------------------------------------------------------------------------------------

          -- Will automatically open the tree when running setup if startup buffer is a file.
          -- File window will be focused.
          -- File will be found if updateFocusedFile is enabled.
          local open_on_setup_file = ${helpers.toLuaObject cfg.openOnSetupFile}

          -- buffer is a real file on the disk
          local real_file = vim.fn.filereadable(data.file) == 1

          if (real_file or no_name) and open_on_setup_file then

            -- skip ignored filetypes
            local filetype = vim.bo[data.buf].ft
            local ignored_filetypes = ${helpers.toLuaObject cfg.ignoreFtOnSetup}

            if not vim.tbl_contains(ignored_filetypes, filetype) then
              -- open the tree but don't focus it
              require("nvim-tree.api").tree.toggle({ focus = false })
              return
            end
          end

          ------------------------------------------------------------------------------------------

          -- Will ignore the buffer, when deciding to open the tree on setup.
          local ignore_buffer_on_setup = ${helpers.toLuaObject cfg.ignoreBufferOnSetup}
          if ignore_buffer_on_setup then
            require("nvim-tree.api").tree.open()
          end

        end
      '';
    in
    mkIf cfg.enable {
      # TODO: added 2024-09-20 remove after 24.11
      plugins.web-devicons = mkIf (
        !(
          config.plugins.mini.enable
          && config.plugins.mini.modules ? icons
          && config.plugins.mini.mockDevIcons
        )
      ) { enable = mkOverride 1490 true; };

      extraPlugins = [
        cfg.package
      ];

      autoCmd =
        (optional autoOpenEnabled {
          event = "VimEnter";
          callback = helpers.mkRaw "open_nvim_tree";
        })
        ++ (optional cfg.autoClose {
          event = "BufEnter";
          command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif";
          nested = true;
        });

      extraConfigLua =
        (optionalString autoOpenEnabled openNvimTreeFunction)
        + ''

          require('nvim-tree').setup(${helpers.toLuaObject setupOptions})
        '';

      extraPackages = [ cfg.gitPackage ];
    };
}
