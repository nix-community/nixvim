{
  lib,
  helpers,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "oil";
  originalName = "oil.nvim";
  package = "oil-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-18: remove 2024-05-18
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "defaultFileExplorer"
    [
      "bufOptions"
      "buflisted"
    ]
    [
      "bufOptions"
      "bufhidden"
    ]
    [
      "winOptions"
      "wrap"
    ]
    [
      "winOptions"
      "signcolumn"
    ]
    [
      "winOptions"
      "cursorcolumn"
    ]
    [
      "winOptions"
      "foldcolumn"
    ]
    [
      "winOptions"
      "spell"
    ]
    [
      "winOptions"
      "list"
    ]
    [
      "winOptions"
      "conceallevel"
    ]
    [
      "winOptions"
      "concealcursor"
    ]
    "deleteToTrash"
    "skipConfirmForSimpleEdits"
    "promptSaveOnSelectNewEntry"
    "cleanupDelayMs"
    "keymaps"
    "useDefaultKeymaps"
    [
      "viewOptions"
      "showHidden"
    ]
    [
      "viewOptions"
      "isHiddenFile"
    ]
    [
      "viewOptions"
      "isAlwaysHidden"
    ]
    [
      "float"
      "padding"
    ]
    [
      "float"
      "maxWidth"
    ]
    [
      "float"
      "maxHeight"
    ]
    [
      "float"
      "border"
    ]
    [
      "float"
      "winOptions"
      "winblend"
    ]
    [
      "preview"
      "maxWidth"
    ]
    [
      "preview"
      "minWidth"
    ]
    [
      "preview"
      "width"
    ]
    [
      "preview"
      "maxHeight"
    ]
    [
      "preview"
      "minHeight"
    ]
    [
      "preview"
      "height"
    ]
    [
      "preview"
      "border"
    ]
    [
      "preview"
      "winOptions"
      "winblend"
    ]
    [
      "progress"
      "maxWidth"
    ]
    [
      "progress"
      "minWidth"
    ]
    [
      "progress"
      "width"
    ]
    [
      "progress"
      "maxHeight"
    ]
    [
      "progress"
      "minHeight"
    ]
    [
      "progress"
      "height"
    ]
    [
      "progress"
      "border"
    ]
    [
      "progress"
      "winOptions"
      "winblend"
    ]
    [
      "progress"
      "minimizedBorder"
    ]
  ];
  imports =
    let
      basePluginPath = [
        "plugins"
        "oil"
      ];
      settingsPath = basePluginPath ++ [ "settings" ];
    in
    [
      (mkRemovedOptionModule (
        basePluginPath ++ [ "columns" ]
      ) "Use `plugins.oil.settings.columns` instead but beware, the format has changed.")
      (mkRenamedOptionModule (basePluginPath ++ [ "lspRenameAutosave" ]) (
        settingsPath
        ++ [
          "lsp_file_method"
          "autosave_changes"
        ]
      ))
      (mkRemovedOptionModule (
        basePluginPath ++ [ "trashCommand" ]
      ) "This option has been deprecated by upstream.")
      (mkRemovedOptionModule (
        basePluginPath ++ [ "restoreWinOptions" ]
      ) "This option has been deprecated by upstream.")
    ];

  settingsOptions =
    let
      dimensionType =
        with types;
        oneOf [
          ints.unsigned
          (numbers.between 0.0 1.0)
          (listOf (either ints.unsigned (numbers.between 0.0 1.0)))
        ];
    in
    {
      default_file_explorer = helpers.defaultNullOpts.mkBool true ''
        Oil will take over directory buffers (e.g. `vim .` or `:e src/`).
        Set to false if you still want to use netrw.
      '';

      columns = mkOption {
        type =
          with lib.types;
          listOf (oneOf [
            str
            (attrsOf anything)
            rawLua
          ]);
        default = [ ];
        description = ''
          Columns can be specified as a string to use default arguments (e.g. `"icon"`),
          or as a table to pass parameters (e.g. `{"size", highlight = "Special"}`)

          Default: `["icon"]`
        '';
        example = [
          "type"
          {
            __unkeyed = "icon";
            highlight = "Foo";
            default_file = "bar";
            directory = "dir";
          }
          "size"
          "permissions"
        ];
      };

      # Buffer-local options to use for oil buffers
      buf_options = {
        buflisted = helpers.defaultNullOpts.mkBool false "";

        bufhidden = helpers.defaultNullOpts.mkStr "hide" "";
      };

      # Window-local options to use for oil buffers
      win_options = {
        wrap = helpers.defaultNullOpts.mkBool false "";

        signcolumn = helpers.defaultNullOpts.mkStr "no" "";

        cursorcolumn = helpers.defaultNullOpts.mkBool false "";

        foldcolumn = helpers.defaultNullOpts.mkStr "0" "";

        spell = helpers.defaultNullOpts.mkBool false "";

        list = helpers.defaultNullOpts.mkBool false "";

        conceallevel = helpers.defaultNullOpts.mkUnsignedInt 3 "";

        concealcursor = helpers.defaultNullOpts.mkStr "nvic" "";
      };

      delete_to_trash = helpers.defaultNullOpts.mkBool false ''
        Deleted files will be removed with the trash_command (below).
      '';

      skip_confirm_for_simple_edits = helpers.defaultNullOpts.mkBool false ''
        Skip the confirmation popup for simple operations.
      '';

      prompt_save_on_select_new_entry = helpers.defaultNullOpts.mkBool true ''
        Selecting a new/moved/renamed file or directory will prompt you to save changes first.
      '';

      cleanup_delay_ms =
        helpers.defaultNullOpts.mkNullable (with types; either types.ints.unsigned (enum [ false ])) 2000
          ''
            Oil will automatically delete hidden buffers after this delay.
            You can set the delay to false to disable cleanup entirely.
            Note that the cleanup process only starts when none of the oil buffers are currently
            displayed.
          '';

      lsp_file_method = {
        timeout_ms = helpers.defaultNullOpts.mkUnsignedInt 1000 ''
          Time to wait for LSP file operations to complete before skipping.
        '';

        autosave_changes = helpers.defaultNullOpts.mkNullable (with types; either bool str) "false" ''
          Set to true to autosave buffers that are updated with LSP `willRenameFiles`.
          Set to "unmodified" to only save unmodified buffers.
        '';
      };

      constrain_cursor =
        helpers.defaultNullOpts.mkNullable (with types; either str (enum [ false ])) "editable"
          ''
            Constrain the cursor to the editable parts of the oil buffer.
            Set to `false` to disable, or "name" to keep it on the file names.
          '';

      experimental_watch_for_changes = helpers.defaultNullOpts.mkBool false ''
        Set to true to watch the filesystem for changes and reload oil.
      '';

      keymaps =
        helpers.defaultNullOpts.mkAttrsOf
          (
            with types;
            oneOf [
              str
              (attrsOf anything)
              (enum [ false ])
            ]
          )
          {
            "g?" = "actions.show_help";
            "<CR>" = "actions.select";
            "<C-s>" = "actions.select_vsplit";
            "<C-h>" = "actions.select_split";
            "<C-t>" = "actions.select_tab";
            "<C-p>" = "actions.preview";
            "<C-c>" = "actions.close";
            "<C-l>" = "actions.refresh";
            "-" = "actions.parent";
            "_" = "actions.open_cwd";
            "`" = "actions.cd";
            "~" = "actions.tcd";
            "gs" = "actions.change_sort";
            "gx" = "actions.open_external";
            "g." = "actions.toggle_hidden";
            "g\\" = "actions.toggle_trash";
          }
          ''
            Keymaps in oil buffer.
            Can be any value that `vim.keymap.set` accepts OR a table of keymap options with a
            `callback` (e.g. `{ callback = function() ... end, desc = "", mode = "n" }`).
            Additionally, if it is a string that matches "actions.<name>", it will use the mapping at
            `require("oil.actions").<name>`.
            Set to `false` to remove a keymap.
            See `:help oil-actions` for a list of all available actions.
          '';

      keymaps_help = helpers.defaultNullOpts.mkAttrsOf types.anything { border = "rounded"; } ''
        Configuration for the floating keymaps help window.
      '';

      use_default_keymaps = helpers.defaultNullOpts.mkBool true ''
        Set to false to disable all of the above keymaps.
      '';

      view_options = {
        show_hidden = helpers.defaultNullOpts.mkBool false ''
          Show files and directories that start with "."
        '';

        is_hidden_file = helpers.defaultNullOpts.mkLuaFn ''
          function(name, bufnr)
            return vim.startswith(name, ".")
          end
        '' "This function defines what is considered a 'hidden' file.";

        is_always_hidden = helpers.defaultNullOpts.mkLuaFn ''
          function(name, bufnr)
            return false
          end
        '' "This function defines what will never be shown, even when `show_hidden` is set.";

        natural_order = helpers.defaultNullOpts.mkBool true ''
          Sort file names in a more intuitive order for humans.
          Is less performant, so you may want to set to `false` if you work with large directories.
        '';

        sort =
          helpers.defaultNullOpts.mkListOf (with types; listOf str)
            [
              [
                "type"
                "asc"
              ]
              [
                "name"
                "asc"
              ]
            ]
            ''
              Sort order can be "asc" or "desc".
              See `:help oil-columns` to see which columns are sortable.
            '';
      };

      float = {
        padding = helpers.defaultNullOpts.mkUnsignedInt 2 "Padding around the floating window.";

        max_width = helpers.defaultNullOpts.mkUnsignedInt 0 "";

        max_height = helpers.defaultNullOpts.mkUnsignedInt 0 "";

        border = helpers.defaultNullOpts.mkBorder "rounded" "oil.open_float" "";

        win_options = {
          winblend = helpers.defaultNullOpts.mkUnsignedInt 0 "";
        };

        override =
          helpers.defaultNullOpts.mkLuaFn
            ''
              function(conf)
                return conf
              end
            ''
            ''
              This is the config that will be passed to `nvim_open_win`.
              Change values here to customize the layout.
            '';
      };

      preview = {
        max_width = helpers.defaultNullOpts.mkNullable dimensionType 0.9 ''
          Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
          Can be a single value or a list of mixed integer/float types.
          `max_width = [100 0.8]` means "the lesser of 100 columns or 80% of total".
        '';

        min_width =
          helpers.defaultNullOpts.mkNullable dimensionType
            [
              40
              0.4
            ]
            ''
              Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
              Can be a single value or a list of mixed integer/float types.
              `min_width = [40 0.4]` means "the greater of 40 columns or 40% of total".
            '';

        width = helpers.mkNullOrOption (
          with types; either int (numbers.between 0.0 1.0)
        ) "Optionally define an integer/float for the exact width of the preview window.";

        max_height = helpers.defaultNullOpts.mkNullable dimensionType 0.9 ''
          Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
          Can be a single value or a list of mixed integer/float types.
          `max_height = [80 0.9]` means "the lesser of 80 columns or 90% of total".
        '';

        min_height =
          helpers.defaultNullOpts.mkNullable dimensionType
            [
              5
              0.1
            ]
            ''
              Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
              Can be a single value or a list of mixed integer/float types.
              `min_height = [5 0.1]` means "the greater of 5 columns or 10% of total".
            '';

        height = helpers.mkNullOrOption (
          with types; either int (numbers.between 0.0 1.0)
        ) "Optionally define an integer/float for the exact height of the preview window.";

        border = helpers.defaultNullOpts.mkStr "rounded" "";

        win_options = {
          winblend = helpers.defaultNullOpts.mkUnsignedInt 0 "";
        };

        update_on_cursor_moved = helpers.defaultNullOpts.mkBool true ''
          Whether the preview window is automatically updated when the cursor is moved.
        '';
      };

      progress = {
        max_width = helpers.defaultNullOpts.mkNullable dimensionType 0.9 ''
          Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
          Can be a single value or a list of mixed integer/float types.
          `max_width = [100 0.8]` means "the lesser of 100 columns or 80% of total".
        '';

        min_width =
          helpers.defaultNullOpts.mkNullable dimensionType
            [
              40
              0.4
            ]
            ''
              Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
              Can be a single value or a list of mixed integer/float types.
              `min_width = [40 0.4]` means "the greater of 40 columns or 40% of total".
            '';

        width = helpers.mkNullOrOption (
          with types; either int (numbers.between 0.0 1.0)
        ) "Optionally define an integer/float for the exact width of the preview window.";

        max_height = helpers.defaultNullOpts.mkNullable dimensionType 0.9 ''
          Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
          Can be a single value or a list of mixed integer/float types.
          `max_height = [80 0.9]` means "the lesser of 80 columns or 90% of total".
        '';

        min_height =
          helpers.defaultNullOpts.mkNullable dimensionType
            [
              5
              0.1
            ]
            ''
              Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
              Can be a single value or a list of mixed integer/float types.
              `min_height = [5 0.1]` means "the greater of 5 columns or 10% of total".
            '';

        height = helpers.mkNullOrOption (
          with types; either int (numbers.between 0.0 1.0)
        ) "Optionally define an integer/float for the exact height of the preview window.";

        border = helpers.defaultNullOpts.mkStr "rounded" "";

        minimized_border = helpers.defaultNullOpts.mkStr "none" "";

        win_options = {
          winblend = helpers.defaultNullOpts.mkUnsignedInt 0 "";
        };
      };

      ssh = {
        border = helpers.defaultNullOpts.mkStr "rounded" ''
          Configuration for the floating SSH window.
        '';
      };
    };

  settingsExample = {
    columns = [ "icon" ];
    view_options.show_hidden = false;
    win_options = {
      wrap = false;
      signcolumn = "no";
      cursorcolumn = false;
      foldcolumn = "0";
      spell = false;
      list = false;
      conceallevel = 3;
      concealcursor = "ncv";
    };
    keymaps = {
      "<C-c>" = false;
      "<leader>qq" = "actions.close";
      "<C-l>" = false;
      "<C-r>" = "actions.refresh";
      "y." = "actions.copy_entry_path";
    };
    skip_confirm_for_simple_edits = true;
  };
}
