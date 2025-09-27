{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "aerial";
  package = "aerial-nvim";
  description = "A code outline window for skimming and quick navigation.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions =
    let
      size =
        with types;
        oneOf [
          rawLua
          ints.unsigned
          (numbers.between 0.0 1.0)
        ];
      listOfSize = with types; either size (listOf size);

      # Several options can have a single value, or a filetype-value mapping.
      mkTypeOrAttrsOfType =
        type: default: description:
        defaultNullOpts.mkNullable (
          with types;
          oneOf [
            rawLua
            type
            (attrsOf type)
          ]
        ) default description;
    in
    {
      backends =
        mkTypeOrAttrsOfType (with types; listOf str)
          [
            "treesitter"
            "lsp"
            "markdown"
            "asciidoc"
            "man"
          ]
          ''
            Priority list of preferred backends for aerial.
            This can be a filetype map (see :help aerial-filetype-map)
          '';

      layout = {
        max_width =
          defaultNullOpts.mkNullable listOfSize
            [
              40
              0.2
            ]
            ''
              Maximum width of the aerial window.
              It can be integers or a float between 0 and 1 (e.g. 0.4 for 40%) or a list of those.
              For example, `[ 40 0.2 ]` means "the lesser of 40 columns or 20% of total".
            '';

        width = defaultNullOpts.mkNullable size null ''
          Width of the aerial window.
          It can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
        '';

        min_width = defaultNullOpts.mkNullable listOfSize 10 ''
          Minimum width of the aerial window.
          It can be integers or a float between 0 and 1 (e.g. 0.4 for 40%) or a list of those.
        '';

        win_opts = defaultNullOpts.mkAttrsOf types.anything { } ''
          Key-value pairs of window-local options for aerial window (e.g. `winhl`).
        '';

        default_direction =
          defaultNullOpts.mkEnumFirstDefault
            [
              "prefer_right"
              "prefer_left"
              "right"
              "left"
              "float"
            ]
            ''
              Determines the default direction to open the aerial window.
              The `prefer_*` options will open the window in the other direction **if** there is a
              different buffer in the way of the preferred direction.
            '';

        placement =
          defaultNullOpts.mkEnum
            [
              "edge"
              "window"
            ]
            "window"
            ''
              Determines where the aerial window will be opened

              - `"edge"`   - open aerial at the far right/left of the editor
              - `"window"` - open aerial to the right/left of the current window
            '';

        resize_to_content = defaultNullOpts.mkBool true ''
          When the symbols change, resize the aerial window (within min/max constraints) to fit.
        '';

        preserve_equality = defaultNullOpts.mkBool false ''
          Preserve window size equality with (`:help CTRL-W_=`).
        '';
      };

      attach_mode =
        defaultNullOpts.mkEnumFirstDefault
          [
            "window"
            "global"
          ]
          ''
            Determines how the aerial window decides which buffer to display symbols for

            - `"window"`: aerial window will display symbols for the buffer in the window from which it was opened
            - `"global"`: aerial window will display symbols for the current window
          '';

      close_automatic_events =
        defaultNullOpts.mkListOf
          (types.enum [
            "unfocus"
            "switch_buffer"
            "unsupported"
          ])
          [ ]
          ''
            List of enum values that configure when to auto-close the aerial window

            - `"unfocus"`: close aerial when you leave the original source window
            - `"switch_buffer"`: close aerial when you change buffers in the source window
            - `"unsupported"`: close aerial when attaching to a buffer that has no symbol source
          '';

      keymaps =
        defaultNullOpts.mkAttrsOf
          (
            with types;
            oneOf [
              str
              (attrsOf anything)
              (enum [ false ])
            ]
          )
          {
            "?" = "actions.show_help";
            "g?" = "actions.show_help";
            "<CR>" = "actions.jump";
            "<2-LeftMouse>" = "actions.jump";
            "<C-v>" = "actions.jump_vsplit";
            "<C-s>" = "actions.jump_split";
            p = "actions.scroll";
            "<C-j>" = "actions.down_and_scroll";
            "<C-k>" = "actions.up_and_scroll";
            "{" = "actions.prev";
            "}" = "actions.next";
            "[[" = "actions.prev_up";
            "]]" = "actions.next_up";
            q = "actions.close";
            o = "actions.tree_toggle";
            za = "actions.tree_toggle";
            O = "actions.tree_toggle_recursive";
            zA = "actions.tree_toggle_recursive";
            l = "actions.tree_open";
            zo = "actions.tree_open";
            L = "actions.tree_open_recursive";
            zO = "actions.tree_open_recursive";
            h = "actions.tree_close";
            zc = "actions.tree_close";
            H = "actions.tree_close_recursive";
            zC = "actions.tree_close_recursive";
            zr = "actions.tree_increase_fold_level";
            zR = "actions.tree_open_all";
            zm = "actions.tree_decrease_fold_level";
            zM = "actions.tree_close_all";
            zx = "actions.tree_sync_folds";
            zX = "actions.tree_sync_folds";
          }
          ''
            Keymaps in aerial window.

            Can be any value that `vim.keymap.set` accepts OR a table of keymap options with a
            `callback` (e.g. `{ callback.__raw = "function() ... end"; desc = ""; nowait = true; }`).

            Additionally, if it is a string that matches "actions.<name>", it will use the mapping at
            `require("aerial.actions").<name>`.

            Set to `false` to remove a keymap.
          '';

      lazy_load = defaultNullOpts.mkBool true ''
        When `true`, don't load aerial until a command or function is called.
        Defaults to `true`, unless `on_attach` is provided, then it defaults to `false`.
      '';

      disable_max_lines = defaultNullOpts.mkUnsignedInt 10000 ''
        Disable aerial on files with this many lines.
      '';

      disable_max_size = defaultNullOpts.mkUnsignedInt 2000000 ''
        Disable aerial on files this size or larger (in bytes).
        Default 2MB.
      '';

      filter_kind =
        mkTypeOrAttrsOfType (with types; either (listOf str) (enum [ false ]))
          [
            "Class"
            "Constructor"
            "Enum"
            "Function"
            "Interface"
            "Module"
            "Method"
            "Struct"
          ]
          ''
            A list of all symbols to display.
            Set to false to display all symbols.
            This can be a filetype map (see `:help aerial-filetype-map`).
            To see all available values, see `:help SymbolKind`.
          '';

      highlight_mode =
        defaultNullOpts.mkEnumFirstDefault
          [
            "split_width"
            "full_width"
            "last"
            "none"
          ]
          ''
            Determines line highlighting mode when multiple splits are visible.

            - `"split_width"`: Each open window will have its cursor location marked in the aerial
              buffer. Each line will only be partially highlighted to indicate which window is at that
              location.
            - `"full_width"`: Each open window will have its cursor location marked as a full-width
              highlight in the aerial buffer.
            - `"last"`: Only the most-recently focused window will have its location marked in the
              aerial buffer.
            - `"none"`: Do not show the cursor locations in the aerial window.
          '';

      highlight_closest = defaultNullOpts.mkBool true ''
        Highlight the closest symbol if the cursor is not exactly on one.
      '';

      highlight_on_hover = defaultNullOpts.mkBool false ''
        Highlight the symbol in the source buffer when cursor is in the aerial win.
      '';

      highlight_on_jump =
        defaultNullOpts.mkNullable (with types; either ints.unsigned (enum [ false ])) 300
          ''
            When jumping to a symbol, highlight the line for this many ms.
            Set to false to disable.
          '';

      autojump = defaultNullOpts.mkBool false ''
        Jump to symbol in source window when the cursor moves.
      '';

      icons = mkTypeOrAttrsOfType (with types; listOf str) [ ] ''
        Define symbol icons.

        You can also specify `"<Symbol>Collapsed"` to change the icon when the tree is collapsed at
        that symbol, or `"Collapsed"` to specify a default collapsed icon.

        The default icon set is determined by the `"nerd_font"` option below.
        If you have lspkind-nvim installed, it will be the default icon set.

        This can be a filetype map (see `:help aerial-filetype-map`).
      '';

      ignore = {
        unlisted_buffers = defaultNullOpts.mkBool false ''
          Ignore unlisted buffers. See `:help buflisted`.
        '';

        diff_windows = defaultNullOpts.mkBool true ''
          Ignore diff windows (setting to false will allow aerial in diff windows).
        '';

        filetypes = defaultNullOpts.mkListOf types.str [ ] ''
          List of filetypes to ignore.
        '';

        buftypes =
          defaultNullOpts.mkNullable
            (
              with types;
              either (listOf str) (enum [
                false
                "special"
              ])

            )
            "special"
            ''
              Ignored buftypes.
              Can be one of the following:
              - `false` or `null`: No buftypes are ignored.
              - `"special"`: All buffers other than normal, help and man page buffers are ignored.
              - list of strings: A list of buftypes to ignore.
                See `:help buftype` for the possible values.
              - function: A function that returns true if the buffer should be ignored or false if
                it should not be ignored.
                Takes two arguments, `bufnr` and `buftype`.
            '';

        wintypes =
          defaultNullOpts.mkNullable
            (
              with types;
              either (listOf str) (enum [
                false
                "special"
              ])
            )
            "special"
            ''
              Ignored buftypes.
              Can be one of the following:
              - `false` or `null`: No wintypes are ignored.
              - `"special"`: All windows other than normal windows are ignored.
              - list of strings: A list of wintypes to ignore.
                See `:help win_gettype()` for the possible values.
              - function: A function that returns true if the window should be ignored or false if
                it should not be ignored.
                Takes two arguments, `winid` and `wintype`.
            '';
      };

      manage_folds = mkTypeOrAttrsOfType (with types; either str bool) false ''
        Use symbol tree for folding.
        Set to `true` or `false` to enable/disable.
        Set to `"auto"` to manage folds if your previous foldmethod was 'manual'
        This can be a filetype map (see :help aerial-filetype-map)
      '';

      link_folds_to_tree = defaultNullOpts.mkBool false ''
        When you fold code with za, zo, or zc, update the aerial tree as well.
        Only works when `manage_folds = true`.
      '';

      link_tree_to_folds = defaultNullOpts.mkBool true ''
        Fold code when you open/collapse symbols in the tree.
        Only works when `manage_folds = true`.
      '';

      nerd_font = defaultNullOpts.mkNullable (with types; either bool (enum [ "auto" ])) "auto" ''
        Set default symbol icons to use patched font icons (see https://www.nerdfonts.com/).
        `"auto"` will set it to `true` if nvim-web-devicons or lspkind-nvim is installed.
      '';

      on_attach = defaultNullOpts.mkRaw "function(bufnr) end" ''
        Call this function when aerial attaches to a buffer.
      '';

      on_first_symbols = defaultNullOpts.mkRaw "function(bufnr) end" ''
        Call this function when aerial first sets symbols on a buffer.
      '';

      open_automatic = defaultNullOpts.mkBool false ''
        Automatically open aerial when entering supported buffers.
        This can be a function (see :help aerial-open-automatic).
      '';

      post_jump_cmd = defaultNullOpts.mkNullable (with types; either (enum [ false ]) str) "normal! zz" ''
        Run this command after jumping to a symbol (`false` will disable).
      '';

      post_parse_symbol =
        defaultNullOpts.mkRaw
          ''
            function(bufnr, item, ctx)
              return true
            end
          ''
          ''
            Invoked after each symbol is parsed, can be used to modify the parsed item, or to filter
            it by returning `false`.

            Arguments:
            - `bufnr`: a neovim buffer number
            - `item`: of type `aerial.Symbol`
            - `ctx`: a record containing the following fields:
              - `backend_name`: treesitter, lsp, man...
              - `lang`: info about the language
              - `symbols?`: specific to the lsp backend
              - `symbol?`: specific to the lsp backend
              - `syntax_tree?`: specific to the treesitter backend
              - `match?`: specific to the treesitter backend, TS query match
          '';

      post_add_all_symbols =
        defaultNullOpts.mkRaw
          ''
            function(bufnr, items, ctx)
              return items
            end
          ''
          ''
            Invoked after all symbols have been parsed and post-processed, allows to modify the
            symbol structure before final display.

            - `bufnr`: a neovim buffer number
            - `items`: a collection of `aerial.Symbol` items, organized in a tree, with 'parent' and
              'children' fields
            - `ctx`: a record containing the following fields:
              - `backend_name`: treesitter, lsp, man...
              - `lang`: info about the language
              - `symbols?`: specific to the lsp backend
              - `syntax_tree?`: specific to the treesitter backend
          '';

      close_on_select = defaultNullOpts.mkBool false ''
        When `true`, aerial will automatically close after jumping to a symbol
      '';

      update_events = defaultNullOpts.mkStr "TextChanged,InsertLeave" ''
        The autocmds that trigger symbols update (not used for LSP backend).
      '';

      show_guides = defaultNullOpts.mkBool false ''
        Whether show box drawing characters for the tree hierarchy.
      '';

      guides =
        defaultNullOpts.mkAttrsOf types.str
          {
            mid_item = "├─";
            last_item = "└─";
            nested_top = "│ ";
            whitespace = "  ";
          }
          ''
            Customize the characters used when `show_guides = true`.
          '';

      get_highlight =
        defaultNullOpts.mkRaw
          ''
            function(symbol, is_icon, is_collapsed)
              -- return "MyHighlight" .. symbol.kind
            end
          ''
          ''
            Set this function to override the highlight groups for certain symbols.
          '';

      float = {
        border = defaultNullOpts.mkNullable (with types; either str (attrsOf anything)) "rounded" ''
          Controls border appearance.
          Passed to `nvim_open_win`.
        '';

        relative =
          defaultNullOpts.mkEnumFirstDefault
            [
              "cursor"
              "editor"
              "win"
            ]
            ''
              Determines location of floating window

              - `"cursor"`: Opens float on top of the cursor
              - `"editor"`: Opens float centered in the editor
              - `"win"`: Opens float centered in the window
            '';

        max_height = defaultNullOpts.mkNullable listOfSize 0.9 ''
          Maximum height of the floating window.
          It can be integers or a float between 0 and 1 (e.g. 0.4 for 40%) or a list of those.
        '';

        height = defaultNullOpts.mkNullable size null ''
          Height of the floating window.
          It can be integers or a float between 0 and 1 (e.g. 0.4 for 40%).
        '';

        min_height =
          defaultNullOpts.mkNullable listOfSize
            [
              8
              0.1
            ]
            ''
              Minimum height of the floating window.
              It can be integers or a float between 0 and 1 (e.g. 0.4 for 40%) or a list of those.
              For example, `[ 8 0.1 ]` means "the greater of 8 rows or 10% of total".
            '';

        override =
          defaultNullOpts.mkRaw
            ''
              function(conf, source_winid)
                -- This is the config that will be passed to nvim_open_win.
                -- Change values here to customize the layout
                return conf
              end
            ''
            ''
              Override the config for a specific window.
            '';
      };

      nav = {
        border = defaultNullOpts.mkStr "rounded" ''
          Border style for the floating nav windows.
        '';

        max_height = defaultNullOpts.mkNullable listOfSize 0.9 ''
          Maximum height of the floating nav windows.
          It can be integers or a float between 0 and 1 (e.g. 0.4 for 40%) or a list of those.
        '';

        min_height =
          defaultNullOpts.mkNullable listOfSize
            [
              10
              0.1
            ]
            ''
              Minimum height of the floating nav windows.
              It can be integers or a float between 0 and 1 (e.g. 0.4 for 40%) or a list of those.
            '';

        max_width = defaultNullOpts.mkNullable listOfSize 0.5 ''
          Minimum width of the floating nav windows.
          It can be integers or a float between 0 and 1 (e.g. 0.4 for 40%) or a list of those.
        '';

        min_width =
          defaultNullOpts.mkNullable listOfSize
            [
              0.2
              20
            ]
            ''
              Minimum width of the floating nav windows.
              It can be integers or a float between 0 and 1 (e.g. 0.4 for 40%) or a list of those.
            '';

        win_opts =
          defaultNullOpts.mkAttrsOf types.anything
            {
              cursorline = true;
              winblend = 10;
            }
            ''
              Key-value pairs of window-local options for aerial window (e.g. `winhl`).
            '';

        autojump = defaultNullOpts.mkBool false ''
          Jump to symbol in source window when the cursor moves.
        '';

        preview = defaultNullOpts.mkBool false ''
          Show a preview of the code in the right column, when there are no child symbols
        '';

        keymaps =
          defaultNullOpts.mkAttrsOf
            (

              with types;
              oneOf [
                str
                (attrsOf anything)
                (enum [ false ])
              ]
            )
            {
              "<CR>" = "actions.jump";
              "<2-LeftMouse>" = "actions.jump";
              "<C-v>" = "actions.jump_vsplit";
              "<C-s>" = "actions.jump_split";
              h = "actions.left";
              l = "actions.right";
              "<C-c>" = "actions.close";
            }
            ''
              Keymaps in the nav window.
            '';
      };

      lsp = {
        diagnostics_trigger_update = defaultNullOpts.mkBool false ''
          If `true`, fetch document symbols when LSP diagnostics update.
        '';

        update_when_errors = defaultNullOpts.mkBool true ''
          Set to false to not update the symbols when there are LSP errors.
        '';

        update_delay = defaultNullOpts.mkUnsignedInt 300 ''
          How long to wait (in ms) after a buffer change before updating.
          Only used when `diagnostics_trigger_update = false`.
        '';

        priority = defaultNullOpts.mkAttrsOf types.int { } ''
          Map of LSP client name to priority.
          Default value is `10`.

          Clients with higher (larger) priority will be used before those with lower priority.
          Set to `-1` to never use the client.
        '';
      };

      treesitter = {
        update_delay = defaultNullOpts.mkUnsignedInt 300 ''
          How long to wait (in ms) after a buffer change before updating.
        '';
      };

      markdown = {
        update_delay = defaultNullOpts.mkUnsignedInt 300 ''
          How long to wait (in ms) after a buffer change before updating.
        '';
      };

      asciidoc = {
        update_delay = defaultNullOpts.mkUnsignedInt 300 ''
          How long to wait (in ms) after a buffer change before updating.
        '';
      };

      man = {
        update_delay = defaultNullOpts.mkUnsignedInt 300 ''
          How long to wait (in ms) after a buffer change before updating.
        '';
      };
    };

  settingsExample = {
    backends = [
      "treesitter"
      "lsp"
      "markdown"
      "man"
    ];
    attach_mode = "global";
    disable_max_lines = 5000;
    highlight_on_hover = true;
    ignore.filetypes = [ "gomod" ];
  };
}
