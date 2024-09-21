{
  lib,
  helpers,
  config,
  pkgs,
  options,
  ...
}:
with lib;
let
  cfg = config.plugins.chadtree;
  mkListStr = helpers.defaultNullOpts.mkNullable (types.listOf types.str);
in
{
  options.plugins.chadtree = helpers.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "chadtree";

    package = lib.mkPackageOption pkgs "chadtree" {
      default = [
        "vimPlugins"
        "chadtree"
      ];
    };

    options = {
      follow = helpers.defaultNullOpts.mkBool true ''
        CHADTree will highlight currently open file, and open all its parents.
      '';

      lang = helpers.mkNullOrOption types.str ''
        CHADTree will guess your locale from unix environmental variables.
        Set to `c` to disable emojis.
      '';

      mimetypes = {
        warn =
          mkListStr
            [
              "audio"
              "font"
              "image"
              "video"
            ]
            ''
              Show a warning before opening these datatypes.
            '';

        allowExts = mkListStr [ ".ts" ] ''
          Skip warning for these extensions.
        '';
      };

      pageIncrement = helpers.defaultNullOpts.mkInt 5 ''
        Change how many lines `{` and `}` scroll.
      '';

      pollingRate = helpers.defaultNullOpts.mkNum 2.0 ''
        CHADTree's background refresh rate.
      '';

      session = helpers.defaultNullOpts.mkBool true ''
        Save & restore currently open folders.
      '';

      showHidden = helpers.defaultNullOpts.mkBool false ''
        Hide some files and folders by default. By default this can be toggled using the `.` key.
        see `chadtree_settings.ignore` for more details.
      '';

      versionControl = helpers.defaultNullOpts.mkBool true ''
        Enable version control. This can also be toggled. But unlike `show_hidden`, does not have a default keybind.
      '';

      ignore = {
        nameExact =
          mkListStr
            [
              ".DS_Store"
              ".directory"
              "thumbs.db"
              ".git"
            ]
            ''
              Files whose name match these exactly will be ignored.
            '';

        nameGlob = mkListStr [ ] ''
          Files whose name match these glob patterns will be ignored.
          ie. `*.py` will match all python files
        '';

        pathGlob = mkListStr [ ] ''
          Files whose full path match these glob patterns will be ignored.
        '';
      };
    };

    view = {
      openDirection =
        helpers.defaultNullOpts.mkEnum
          [
            "left"
            "right"
          ]
          "left"
          ''
            Which way does CHADTree open?
          '';

      sortBy =
        mkListStr
          [
            "is_folder"
            "ext"
            "file_name"
          ]
          ''
            CHADTree can sort by the following criterion.
            Reorder them if you want a different sorting order.
            legal keys: some of
            `["is_folder" "ext" "file_name"]`
          '';

      width = helpers.defaultNullOpts.mkInt 40 ''
        How big is CHADTree when initially opened?
      '';

      windowOptions =
        helpers.defaultNullOpts.mkAttributeSet
          ''
            {
                cursorline = true;
                number = false;
                relativenumber = false;
                signcolumn = "no";
                winfixwidth = true;
                wrap = false;
            }
          ''
          ''
            Set of window local options to for CHADTree windows.
          '';
    };

    theme = {
      highlights = {
        ignored = helpers.defaultNullOpts.mkStr "Comment" ''
          These are used for files that are ignored by user supplied pattern
          in `chadtree.ignore` and by version control.
        '';

        bookmarks = helpers.defaultNullOpts.mkStr "Title" ''
          These are used to show bookmarks.
        '';

        quickfix = helpers.defaultNullOpts.mkStr "Label" ''
          These are used to notify the number of times a file / folder appears in the `quickfix` list.
        '';

        versionControl = helpers.defaultNullOpts.mkStr "Comment" ''
          These are used to put a version control status beside each file.
        '';
      };

      iconGlyphSet =
        helpers.defaultNullOpts.mkEnum
          [
            "devicons"
            "emoji"
            "ascii"
            "ascii_hollow"
          ]
          "devicons"
          ''
            Icon glyph set to use.
          '';

      textColourSet =
        helpers.defaultNullOpts.mkEnum
          [
            "env"
            "solarized_dark_256"
            "solarized_dark"
            "solarized_light"
            "solarized_universal"
            "nord"
            "trapdoor"
            "nerdtree_syntax_light"
            "nerdtree_syntax_dark"
          ]
          "env"
          ''
            On `unix`, the command `ls` can produce coloured results based on the `LS_COLORS` environmental variable.

            CHADTree can pretend it's `ls` by setting `chadtree.theme.textColourSet` to `env`.

            If you are not happy with that, you can choose one of the many others.
          '';

      iconColourSet =
        helpers.defaultNullOpts.mkEnum
          [
            "github"
            "none"
          ]
          "github"
          ''
            Right now you all the file icons are coloured according to Github colours.

            You may also disable colouring if you wish.
          '';
    };

    keymap = {
      windowManagement = {
        quit = mkListStr [ "q" ] ''
          Close CHADTree window, quit if it is the last window.
        '';

        bigger =
          mkListStr
            [
              "+"
              "="
            ]
            ''
              Resize CHADTree window bigger.
            '';

        smaller =
          mkListStr
            [
              "-"
              "_"
            ]
            ''
              Resize CHADTree window smaller.
            '';

        refresh = mkListStr [ "<c-r>" ] ''
          Refresh CHADTree.
        '';
      };

      rerooting = {
        changeDir = mkListStr [ "b" ] ''
          Change vim's working directory.
        '';

        changeFocus = mkListStr [ "c" ] ''
          Set CHADTree's root to folder at cursor. Does not change working directory.
        '';

        changeFocusUp = mkListStr [ "C" ] ''
          Set CHADTree's root one level up.
        '';
      };

      openFileFolder = {
        primary = mkListStr [ "<enter>" ] ''
          Open file at cursor.
        '';

        secondary = mkListStr [ "<tab> <2-leftmouse>" ] ''
          Open file at cursor, keep cursor in CHADTree's window.
        '';

        tertiary =
          mkListStr
            [
              "<m-enter>"
              "<middlemouse>"
            ]
            ''
              Open file at cursor in a new tab.
            '';

        vSplit = mkListStr [ "w" ] ''
          Open file at cursor in vertical split.
        '';

        hSplit = mkListStr [ "W" ] ''
          Open file at cursor in horizontal split.
        '';

        openSys = mkListStr [ "o" ] ''
          Open file with GUI tools using `open` or `xdg open`.
          This will open third party tools such as Finder or KDE Dolphin or GNOME nautilus, etc.
          Depends on platform and user setup.
        '';

        collapse = mkListStr [ "o" ] ''
          Collapse all subdirectories for directory at cursor.
        '';
      };

      cursor = {
        refocus = mkListStr [ "~" ] ''
          Put cursor at the root of CHADTree.
        '';

        jumpToCurrent = mkListStr [ "J" ] ''
          Position cursor in CHADTree at currently open buffer, if the buffer points to a location visible under CHADTree.
        '';

        stat = mkListStr [ "K" ] ''
          Print `ls --long` stat for file under cursor.
        '';

        copyName = mkListStr [ "y" ] ''
          Copy paths of files under cursor or visual block.
        '';

        copyBasename = mkListStr [ "Y" ] ''
          Copy names of files under cursor or visual block.
        '';

        copyRelname = mkListStr [ "<c-y>" ] ''
          Copy relative paths of files under cursor or visual block.
        '';
      };

      filtering = {
        filter = mkListStr [ "f" ] ''
          Set a glob pattern to narrow down visible files.
        '';

        clearFilter = mkListStr [ "F" ] ''
          Clear filter.
        '';
      };

      bookmarks = {
        bookmarkGoto = mkListStr [ "m" ] ''
          Goto bookmark `A-Z`.
        '';
      };

      selecting = {
        select = mkListStr [ "s" ] ''
          Select files under cursor or visual block.
        '';

        clearSelection = mkListStr [ "S" ] ''
          Clear selection.
        '';
      };

      fileOperations = {
        new = mkListStr [ "a" ] ''
          Create new file at location under cursor. Files ending with platform specific path separator will be folders.

          Intermediary folders are created automatically.

          ie. `uwu/owo/` under unix will create `uwu/` then `owo/` under it. Both are folders.
        '';

        link = mkListStr [ "A" ] ''
          Create links at location under cursor from selection.

          Links are always relative.

          Intermediary folders are created automatically.
        '';

        rename = mkListStr [ "r" ] ''
          Rename file under cursor.
        '';

        toggleExec = mkListStr [ "X" ] ''
          Toggle all the `+x` bits of the selected / highlighted files.

          Except for directories, where `-x` will prevent reading.
        '';

        copy = mkListStr [ "p" ] ''
          Copy the selected files to location under cursor.
        '';

        cut = mkListStr [ "x" ] ''
          Move the selected files to location under cursor.
        '';

        delete = mkListStr [ "d" ] ''
          Delete the selected files. Items deleted cannot be recovered.
        '';

        trash = mkListStr [ "t" ] ''
          Trash the selected files using platform specific `trash` command, if they are available.
          Items trashed may be recovered.
        '';
      };

      toggles = {
        toggleHidden = mkListStr [ "." ] ''
          Toggle show_hidden on and off. See `chadtree.showHidden` for details.
        '';

        toggleFollow = mkListStr [ "u" ] ''
          Toggle `follow` on and off. See `chadtree.follow` for details.
        '';

        toggleVersionControl = mkListStr [ "i" ] ''
          Toggle version control integration on and off.
        '';
      };
    };
  };

  config =
    let
      setupOptions = with cfg; {
        xdg = true;
        options = with cfg.options; {
          inherit follow;
          inherit lang;
          mimetypes = with mimetypes; {
            inherit warn;
            allow_exts = allowExts;
          };
          page_increment = pageIncrement;
          polling_rate = pollingRate;
          inherit session;
          show_hidden = showHidden;
          version_control = versionControl;
          ignore = with ignore; {
            name_exact = nameExact;
            name_glob = nameGlob;
            path_glob = pathGlob;
          };
        };
        view = with view; {
          open_direction = openDirection;
          sort_by = sortBy;
          inherit width;
          window_options = windowOptions;
        };
        theme = with theme; {
          highlights = with highlights; {
            inherit ignored;
            inherit bookmarks;
            inherit quickfix;
            version_control = versionControl;
          };
          icon_glyph_set = iconGlyphSet;
          text_colour_set = textColourSet;
          icon_colour_set = iconColourSet;
        };
        keymap =
          with keymap;
          with windowManagement;
          with rerooting;
          with openFileFolder;
          with cursor;
          with filtering;
          with bookmarks;
          with selecting;
          with fileOperations;
          with toggles;
          {
            inherit quit;
            inherit bigger;
            inherit smaller;
            inherit refresh;
            change_dir = changeDir;
            change_focus = changeFocus;
            change_focus_up = changeFocusUp;
            inherit primary;
            inherit secondary;
            inherit tertiary;
            v_split = vSplit;
            h_split = hSplit;
            open_sys = openSys;
            inherit collapse;
            inherit refocus;
            jump_to_current = jumpToCurrent;
            inherit stat;
            copy_name = copyName;
            copy_basename = copyBasename;
            copy_relname = copyRelname;
            inherit filter;
            clear_filter = clearFilter;
            bookmark_goto = bookmarkGoto;
            inherit select;
            clear_selection = clearSelection;
            inherit new;
            inherit link;
            inherit rename;
            toggle_exec = toggleExec;
            inherit copy;
            inherit cut;
            inherit delete;
            inherit trash;
            toggle_hidden = toggleHidden;
            toggle_follow = toggleFollow;
            toggle_version_control = toggleVersionControl;
          };
      };
    in
    mkIf cfg.enable {
      # TODO: added 2024-09-20 remove after 24.11
      plugins.web-devicons =
        lib.mkIf
          (
            (cfg.theme == null || cfg.theme.iconGlyphSet == "devicons")
            && !(
              config.plugins.mini.enable
              && config.plugins.mini.modules ? icons
              && config.plugins.mini.mockDevIcons
            )
          )
          {
            enable = lib.mkOverride 1490 false;
          };

      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        vim.api.nvim_set_var("chadtree_settings", ${helpers.toLuaObject setupOptions})
      '';
    };
}
