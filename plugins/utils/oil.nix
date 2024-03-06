{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.oil;

  fractionType = types.numbers.between 0.0 1.0;

  mkSizeOption =
    helpers.defaultNullOpts.mkNullable
    (with types;
      oneOf [
        int
        fractionType
        (listOf (either int fractionType))
      ]);

  commonWindowOptions = {
    maxWidth = mkSizeOption "0.9" ''
      Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
      Can be a single value or a list of mixed integer/float types.
      maxWidth = [100 0.8] means "the lesser of 100 columns or 80% of total".
    '';

    minWidth = mkSizeOption "[40 0.4]" ''
      Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
      Can be a single value or a list of mixed integer/float types.
      minWidth = [40 0.4] means "the greater of 40 columns or 40% of total".
    '';

    width =
      helpers.mkNullOrOption (with types; either int fractionType)
      "Optionally define an integer/float for the exact width of the preview window.";

    maxHeight = mkSizeOption "0.9" ''
      Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
      Can be a single value or a list of mixed integer/float types.
      maxHeight = [80 0.9] means "the lesser of 80 columns or 90% of total".
    '';

    minHeight = mkSizeOption "[5 0.1]" ''
      Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
      Can be a single value or a list of mixed integer/float types.
      minHeight = [5 0.1] means "the greater of 5 columns or 10% of total".
    '';

    height =
      helpers.mkNullOrOption (with types; either int fractionType)
      "Optionally define an integer/float for the exact height of the preview window.";

    border = helpers.defaultNullOpts.mkBorder "rounded" "oil" "";

    winOptions = {
      winblend = helpers.defaultNullOpts.mkInt 0 "";
    };
  };
in {
  options.plugins.oil =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "oil";

      package = helpers.mkPackageOption "oil" pkgs.vimPlugins.oil-nvim;

      columns = let
        highlightsOption = helpers.mkNullOrOption (with types; either str helpers.nixvimTypes.rawLua) ''
          A string or a lua function (`fun(value: string): string`).
          Highlight group, or function that returns a highlight group.
        '';

        formatOption = helpers.mkNullOrOption types.str "Format string (see :help strftime)";
      in {
        type = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to enable the type column.
              The type of the entry (file, directory, link, etc).

              Adapters: *
            '';
          };

          highlight = highlightsOption;

          icons = helpers.mkNullOrOption (with types; attrsOf str) ''
            Mapping of entry type to icon.
          '';
        };

        icon = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to enable the icon column.
              An icon for the entry's type (requires nvim-web-devicons).

              Adapters: *
            '';
          };

          highlight = highlightsOption;

          defaultFile = helpers.mkNullOrOption types.str ''
            Fallback icon for files when nvim-web-devicons returns nil.
          '';

          directory = helpers.mkNullOrOption types.str "Icon for directories.";
        };

        size = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to enable the size column.
              The size of the file.

              Adapters: files, ssh
            '';
          };

          highlight = highlightsOption;
        };

        permissions = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to enable the perimissions column.
              Access permissions of the file.

              Adapters: files, ssh
              Editable: this column is read/write
            '';
          };

          highlight = highlightsOption;
        };

        ctime = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to enable the ctime column.
              Change timestamp of the file.

              Adapters: files
            '';
          };

          highlight = highlightsOption;

          format = formatOption;
        };

        mtime = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to enable the mtime column.
              Last modified time of the file.

              Adapters: files
            '';
          };

          highlight = highlightsOption;

          format = formatOption;
        };

        atime = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to enable the atime column.
              Last access time of the file.

              Adapters: files
            '';
          };

          highlight = highlightsOption;

          format = formatOption;
        };

        birthtime = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to enable the birthtime column.
              The time the file was created.

              Adapters: files
            '';
          };

          highlight = highlightsOption;

          format = formatOption;
        };
      };

      # Buffer-local options to use for oil buffers
      bufOptions = {
        buflisted = helpers.defaultNullOpts.mkBool false "";

        bufhidden = helpers.defaultNullOpts.mkStr "hide" "";
      };

      # Window-local options to use for oil buffers
      winOptions = {
        wrap = helpers.defaultNullOpts.mkBool false "";

        signcolumn = helpers.defaultNullOpts.mkStr "no" "";

        cursorcolumn = helpers.defaultNullOpts.mkBool false "";

        foldcolumn = helpers.defaultNullOpts.mkStr "0" "";

        spell = helpers.defaultNullOpts.mkBool false "";

        list = helpers.defaultNullOpts.mkBool false "";

        conceallevel = helpers.defaultNullOpts.mkInt 3 "";

        concealcursor = helpers.defaultNullOpts.mkStr "n" "";
      };

      defaultFileExplorer =
        helpers.defaultNullOpts.mkBool true
        "Oil will take over directory buffers (e.g. `vim .` or `:e src/`.";

      restoreWinOptions =
        helpers.defaultNullOpts.mkBool true
        "Restore window options to previous values when leaving an oil buffer";

      skipConfirmForSimpleEdits =
        helpers.defaultNullOpts.mkBool false
        "Skip the confirmation popup for simple operations.";

      deleteToTrash =
        helpers.defaultNullOpts.mkBool false
        "Deleted files will be removed with the trash_command (below).";

      trashCommand =
        helpers.defaultNullOpts.mkStr "trash-put"
        "Change this to customize the command used when deleting to trash.";

      promptSaveOnSelectNewEntry =
        helpers.defaultNullOpts.mkBool true
        "Selecting a new/moved/renamed file or directory will prompt you to save changes first.";

      cleanupDelayMs =
        helpers.defaultNullOpts.mkNullable
        (types.either types.int (types.enum [false]))
        "2000" ''
          Oil will automatically delete hidden buffers after this delay.
          You can set the delay to false to disable cleanup entirely.
          Note that the cleanup process only starts when none of the oil buffers are currently displayed
        '';

      lspRenameAutosave =
        helpers.defaultNullOpts.mkNullable
        (types.either types.bool (types.enum ["unmodified"]))
        "false"
        "Set to true to autosave buffers that are updated with LSP willRenameFiles. Set to \"unmodified\" to only save unmodified buffers";

      keymaps =
        helpers.defaultNullOpts.mkNullable
        types.attrs
        "see documentation"
        ''
          Keymaps in oil buffer.
          Can be any value that `vim.keymap.set` accepts OR a table of keymap options with a
          `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
          Additionally, if it is a string that matches "actions.<name>", it will use the mapping at
          require("oil.actions").<name>

          Set to `false` to remove a keymap.
          See :help oil-actions for a list of all available actions.
        '';

      useDefaultKeymaps = helpers.defaultNullOpts.mkBool true ''
        Set to false to disable all of the default keymaps.
      '';

      viewOptions = {
        showHidden = helpers.defaultNullOpts.mkBool false ''
          Show files and directories that start with "."
        '';

        isHiddenFile =
          helpers.defaultNullOpts.mkLuaFn
          ''
            function(name, bufnr)
              return vim.startswith(name, ".")
            end
          ''
          "This function defines what is considered a 'hidden' file.";

        isAlwaysHidden =
          helpers.defaultNullOpts.mkLuaFn
          ''
            function(name, bufnr)
              return false
            end
          ''
          "This function defines what will never be shown, even when `show_hidden` is set.";
      };

      # Configuration for the floating window in oil.open_float
      float = {
        padding = helpers.defaultNullOpts.mkInt 2 "Padding around the floating window.";

        maxWidth = helpers.defaultNullOpts.mkInt 0 "";

        maxHeight = helpers.defaultNullOpts.mkInt 0 "";

        border = helpers.defaultNullOpts.mkBorder "rounded" "oil.open_float" "";

        winOptions = {
          winblend = helpers.defaultNullOpts.mkInt 10 "";
        };
      };

      # Configuration for the actions floating preview window
      preview = commonWindowOptions;

      # Configuration for the floating progress window
      progress =
        commonWindowOptions
        // {
          minimizedBorder = helpers.defaultNullOpts.mkBorder "none" "oil floating progress window" "";
        };
    };

  config = let
    options =
      {
        columns = with cfg.columns;
          (optional type.enable {
            "__unkeyed" = "type";
            inherit (type) highlight icons;
          })
          ++ (optional icon.enable {
            "__unkeyed" = "icon";
            inherit (icon) highlight defaultFile directory;
          })
          ++ (optional size.enable {
            "__unkeyed" = "size";
            inherit (size) highlight;
          })
          ++ (optional permissions.enable {
            "__unkeyed" = "permissions";
            inherit (permissions) highlight;
          })
          ++ (optional ctime.enable {
            "__unkeyed" = "ctime";
            inherit (ctime) highlight format;
          })
          ++ (optional mtime.enable {
            "__unkeyed" = "mtime";
            inherit (mtime) highlight format;
          })
          ++ (optional atime.enable {
            "__unkeyed" = "atime";
            inherit (atime) highlight format;
          })
          ++ (optional birthtime.enable {
            "__unkeyed" = "birthtime";
            inherit (birthtime) highlight format;
          });
        buf_options = cfg.bufOptions;
        win_options = cfg.winOptions;
        default_file_explorer = cfg.defaultFileExplorer;
        restore_win_options = cfg.restoreWinOptions;
        skip_confirm_for_simple_edits = cfg.skipConfirmForSimpleEdits;
        delete_to_trash = cfg.deleteToTrash;
        trash_command = cfg.trashCommand;
        prompt_save_on_select_new_entry = cfg.promptSaveOnSelectNewEntry;
        lsp_rename_autosave = cfg.lspRenameAutosave;
        cleanup_delay_ms = cfg.cleanupDelayMs;
        inherit (cfg) keymaps;
        use_default_keymaps = cfg.useDefaultKeymaps;
        view_options = with cfg.viewOptions; {
          show_hidden = showHidden;
          is_hidden_file = isHiddenFile;
          is_always_hidden = isAlwaysHidden;
        };
        float = with cfg.float; {
          inherit padding;
          max_width = maxWidth;
          max_height = maxHeight;
          inherit border;
          win_options = with winOptions; {
            inherit winblend;
          };
        };
        preview = with cfg.preview; {
          max_width = maxWidth;
          min_width = minWidth;
          inherit width;
          max_height = maxHeight;
          min_height = maxHeight;
          inherit height border;
          win_options = {
            inherit (winOptions) winblend;
          };
        };
        progress = with cfg.progress; {
          max_width = maxWidth;
          min_width = minWidth;
          inherit width;
          max_height = maxHeight;
          min_height = maxHeight;
          inherit height border;
          minimized_border = minimizedBorder;
          win_options = {
            inherit (winOptions) winblend;
          };
        };
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require('oil').setup(${helpers.toLuaObject options})
      '';
    };
}
