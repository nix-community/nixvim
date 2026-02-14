lib:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts literalLua mkNullOrOption;

  mkPadding =
    defaultNullOpts.mkNullable
      (types.submodule {
        options = lib.genAttrs [ "left" "right" ] (
          side:
          lib.mkOption {
            type = types.ints.unsigned;
            description = "Padding for the ${side} side.";
          }
        );
      })
      {
        left = 1;
        right = 1;
      };
in
{
  bar = {
    enable =
      defaultNullOpts.mkBool
        (literalLua ''
          function(buf, win, _)
            if
              not vim.api.nvim_buf_is_valid(buf)
              or not vim.api.nvim_win_is_valid(win)
              or vim.fn.win_gettype(win) ~= ""
              or vim.wo[win].winbar ~= ""
              or vim.bo[buf].ft == 'help'
            then
              return false
            end

            local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
            if stat and stat.size > 1024 * 1024 then
              return false
            end

            return vim.bo[buf].ft == 'markdown'
              or pcall(vim.treesitter.get_parser, buf)
              or not vim.tbl_isempty(vim.lsp.get_clients({
                bufnr = buf,
                method = 'textDocument/documentSymbol',
              }))
            end
        '')
        ''
          Controls whether to enable the plugin for the current buffer and window.

          If a function is provided, it will be called with the current `bufnr` and `winid` and
          should return a boolean.
        '';

    attach_events =
      defaultNullOpts.mkListOf types.str
        [
          "OptionSet"
          "BufWinEnter"
          "BufWritePost"
        ]
        ''
          Controls when to evaluate the `enable()` function and attach the plugin to corresponding
          buffer or window.
        '';

    update_debounce = defaultNullOpts.mkUnsignedInt 0 ''
      Wait for a short time before updating the winbar, if another update request is received within
      this time, the previous request will be cancelled.
      This improves the performance when the user is holding down a key (e.g. `'j'`) to scroll the
      window.

      If you encounter performance issues when scrolling the window, try setting this option to a
      number slightly larger than `1000 / key_repeat_rate`.
    '';

    update_events = {
      win =
        defaultNullOpts.mkListOf types.str
          [
            "CursorMoved"
            "WinEnter"
            "WinResized"
          ]
          ''
            List of events that should trigger an update on the dropbar attached to a single window.
          '';

      buf =
        defaultNullOpts.mkListOf types.str
          [
            "BufModifiedSet"
            "FileChangedShellPost"
            "TextChanged"
            "ModeChanged"
          ]
          ''
            List of events that should trigger an update on all dropbars attached to a buffer.
          '';

      global =
        defaultNullOpts.mkListOf types.str
          [
            "DirChanged"
            "VimResized"
          ]
          ''
            List of events that should trigger an update on all dropbars in the current nvim
            session.
          '';
    };

    hover = defaultNullOpts.mkBool true ''
      Whether to highlight the symbol under the cursor.

      This feature requires 'mousemoveevent' to be enabled.
    '';

    sources =
      defaultNullOpts.mkListOf
        (types.submodule {
          freeformType = with types; attrsOf anything;

          options = {
            get_symbols = mkNullOrOption types.rawLua ''
              ```lua
              fun(buf: integer, win: integer, cursor: integer[]): dropbar_symbol_t[]
              ```
            '';
          };
        })
        (literalLua ''
          function(buf, _)
            local sources = require('dropbar.sources')
            local utils = require('dropbar.utils')
            if vim.bo[buf].ft == 'markdown' then
              return {
                sources.path,
                sources.markdown,
              }
            end
            if vim.bo[buf].buftype == 'terminal' then
              return {
                sources.terminal,
              }
            end
            return {
              sources.path,
              utils.source.fallback({
                sources.lsp,
                sources.treesitter,
              }),
            }
          end
        '')
        ''
          List of sources to show in the winbar.

          If a function is provided, it will be called with the current `bufnr` and `winid` and
          should return a list of sources.

          For more information about sources, see `|dropbar-developers-classes-dropbar_source_t|`.
        '';

    padding = mkPadding ''
      Padding to use between the winbar and the window border.
    '';

    pick = {
      pivots = defaultNullOpts.mkStr "abcdefghijklmnopqrstuvwxyz" ''
        Pivots to use in pick mode.
      '';
    };

    truncate = defaultNullOpts.mkBool true ''
      Whether to truncate the winbar if it doesn’t fit in the window.
    '';
  };

  menu = {
    quick_navigation = defaultNullOpts.mkBool true ''
      When on, automatically set the cursor to the closest previous/next clickable component in the
      direction of cursor movement on `|CursorMoved|`.
    '';

    entry = {
      padding = mkPadding ''
        Padding to use between the menu entry and the menu border.
      '';
    };

    preview = defaultNullOpts.mkBool true ''
      Whether to enable previewing for menu entries.
    '';

    keymaps = mkNullOrOption (with types; attrsOf (either str (attrsOf (maybeRaw str)))) ''
      Buffer-local keymaps in the menu.

      Use `<key> = <function|string>` to map a key in normal mode in the menu buffer, or use
      `<key> = table<mode, function|string>` to map a key in specific modes.

       See `:h dropbar-configuration-options-menu` for the default value.
    '';

    scrollbar =
      defaultNullOpts.mkAttrsOf types.bool
        {
          enable = true;
          background = true;
        }
        ''
          Scrollbar configuration for the menu.
        '';

    win_configs = mkNullOrOption (with types; attrsOf anything) ''
      Window configurations for the menu, see `:h nvim_open_win()`.

      Each config key in `menu.win_configs` accepts either a plain value which will be passed
      directly to `nvim_open_win()`, or a function that takes the current `menu` (see
      `|dropbar-developers-classes-dropbar_menu_t|`) as an argument and returns a value to be
      passed to `nvim_open_win()`.

      See `:h dropbar-configuration-options-menu` for the default value.
    '';
  };

  fzf = {
    keymaps = mkNullOrOption (with types; attrsOf (maybeRaw str)) ''
      The keymaps that will apply in insert mode, in the fzf prompt buffer.

      See `:h dropbar-configuration-options-fzf` for the default value.
    '';

    win_configs = mkNullOrOption (with types; attrsOf anything) ''
      Options passed to `:h nvim_open_win`.

      The fuzzy finder will use its parent window's config by default, but options set here will
      override those.
      Same config as `menu.win_configs`

      See `:h dropbar-configuration-options-fzf` for the default value.
    '';

    prompt = defaultNullOpts.mkStr "%#htmlTag# " ''
      Prompt string that will be displayed in the `statuscolumn` of the fzf input window.

      Can include highlight groups
    '';

    char_pattern = defaultNullOpts.mkStr "[%w%p]" ''
      Character pattern.
    '';

    retain_inner_spaces = defaultNullOpts.mkBool true ''
      Whether to retain inner spaces.
    '';

    fuzzy_find_on_click = defaultNullOpts.mkBool true ''
      When opening an entry with a submenu via the fuzzy finder, open the submenu in fuzzy finder
      mode.
    '';
  };

  icons = {
    enable = defaultNullOpts.mkBool true ''
      Whether to enable icons.
    '';

    kinds = {
      dir_icon =
        defaultNullOpts.mkStr
          (literalLua ''
            function(_)
              return M.opts.icons.kinds.symbols.Folder, 'DropBarIconKindFolder'
            end
          '')
          ''
            Directory icon and highlighting getter, set to empty string to disable.
          '';

      file_icon =
        defaultNullOpts.mkStr
          (literalLua ''
            function(path)
              return M.opts.icons.kinds.symbols.File, 'DropBarIconKindFile'
            end
          '')
          ''
            File icon and highlighting getter, set to empty string to disable.
          '';

      symbols = mkNullOrOption (with types; attrsOf str) ''
        Table mapping the different kinds of symbols to their corresponding icons.

        See `:h dropbar-configuration-options-icons` for the default value.
      '';
    };

    ui = {
      bar =
        defaultNullOpts.mkAttrsOf types.str
          {
            separator = " ";
            extends = "…";
          }
          ''
            Controls the icons used in the winbar UI.
          '';

      menu =
        defaultNullOpts.mkAttrsOf types.str
          {
            separator = " ";
            indicator = " ";
          }
          ''
            Controls the icons used in the menu UI.
          '';
    };
  };

  symbol = {
    on_click = mkNullOrOption (with types; maybeRaw (enum [ false ])) ''
      function called when clicking or pressing `<CR>` on the symbol.

      See `:h dropbar-configuration-options-symbol` for the default value.
    '';

    preview = {
      reorient =
        defaultNullOpts.mkRaw
          ''
            function(_, range)
              local invisible = range['end'].line - vim.fn.line('w$') + 1
              if invisible > 0 then
                local view = vim.fn.winsaveview() --[[@as vim.fn.winrestview.dict]]
                view.topline = math.min(
                  view.topline + invisible,
                  math.max(1, range.start.line - vim.wo.scrolloff + 1)
                )
                vim.fn.winrestview(view)
              end
            end
          ''
          ''
            Function to reorient the source window when previewing symbol given the source window
            `win` and the range of the symbol `range`.
          '';
    };

    jump = {
      reorient =
        defaultNullOpts.mkRaw
          ''
            function(win, range)
              local view = vim.fn.winsaveview()
              local win_height = vim.api.nvim_win_get_height(win)
              local topline = range.start.line - math.floor(win_height / 4)
              if
                topline > view.topline
                and topline + win_height < vim.fn.line('$')
              then
                view.topline = topline
                vim.fn.winrestview(view)
              end
            end
          ''
          ''
            Function to reorient the source window when jumping to symbol given the source window
            `win` and the range of the symbol `range`.
          '';
    };
  };

  sources = {
    path = {
      max_depth = defaultNullOpts.mkUnsignedInt 16 ''
        Maximum number of symbols to return.

        A smaller number can help to improve performance in deeply nested paths.
      '';

      relative_to =
        defaultNullOpts.mkStr
          (literalLua ''
            function(_, win)
              -- Workaround for Vim:E5002: Cannot find window number
              local ok, cwd = pcall(vim.fn.getcwd, win)
              return ok and cwd or vim.fn.getcwd()
            end
          '')
          ''
            The path to use as the root of the relative path.

            If a function is provided, it will be called with the current buffer number and window
            id as arguments and should return a string to be used as the root of the relative path.

            Notice: currently does not support `..` relative paths.
          '';

      path_filter = defaultNullOpts.mkRaw "function(_) return true end" ''
        A function that takes a file name and returns whether to include it in the results shown in
        the drop-down menu.
      '';

      modified = defaultNullOpts.mkRaw "function(sym) return sym end" ''
        A function that takes the last symbol in the result got from the path source and returns an
        alternative symbol to show if the current buffer is modified.

        For information about dropbar symbols, see `|dropbar-developers-classes-dropbar_symbol_t|`.

        To set a different icon, name, or highlights when the buffer is modified, you can change the
        corresponding fields in the returned symbol:

        ```lua
        function(sym)
          return sym:merge({
            name = sym.name .. ' [+]',
            icon = ' ',
            name_hl = 'DiffAdded',
            icon_hl = 'DiffAdded',
            -- ...
          })
        end
        ```
      '';

      preview =
        defaultNullOpts.mkBool
          (literalLua ''
            function(path)
              local stat = vim.uv.fs_stat(path)
              if not stat or stat.type ~= 'file' then
                return false
              end
              if stat.size > 524288 then
                vim.notify(
                  string.format(
                    '[dropbar.nvim] file "%s" too large to preview',
                    path
                  ),
                  vim.log.levels.WARN
                )
                return false
              end
              return true
            end
          '')
          ''
            A boolean or a function that takes a file path and returns whether to preview the file
            under cursor.
          '';
    };

    treesitter = {
      max_depth = defaultNullOpts.mkUnsignedInt 16 ''
        Maximum number of symbols to return.

        A smaller number can help to improve performance in deeply nested trees (e.g. in big nested
        json files).
      '';

      name_regex = defaultNullOpts.mkStr "[=[[#~!@\\*&.]*[[:keyword:]]\\+!\\?\\(\\(\\(->\\)\\+\\|-\\+\\|\\.\\+\\|:\\+\\|\\s\\+\\)\\?[#~!@\\*&.]*[[:keyword:]]\\+!\\?\\)*]=]" ''
        Vim regex used to extract a short name from the node text.
      '';

      valid_types =
        defaultNullOpts.mkListOf types.str
          [
            "array"
            "boolean"
            "break_statement"
            "call"
            "case_statement"
            "class"
            "constant"
            "constructor"
            "continue_statement"
            "delete"
            "do_statement"
            "element"
            "enum"
            "enum_member"
            "event"
            "for_statement"
            "function"
            "h1_marker"
            "h2_marker"
            "h3_marker"
            "h4_marker"
            "h5_marker"
            "h6_marker"
            "if_statement"
            "interface"
            "keyword"
            "macro"
            "method"
            "module"
            "namespace"
            "null"
            "number"
            "operator"
            "package"
            "pair"
            "property"
            "reference"
            "repeat"
            "rule_set"
            "scope"
            "specifier"
            "struct"
            "switch_statement"
            "type"
            "type_parameter"
            "unit"
            "value"
            "variable"
            "while_statement"
            "declaration"
            "field"
            "identifier"
            "object"
            "statement"
          ]
          ''
            A list of treesitter node types to include in the results.
          '';
    };

    lsp = {
      max_depth = defaultNullOpts.mkUnsignedInt 16 ''
        Maximum number of symbols to return.

        A smaller number can help to improve performance when the language server returns huge list
        of nested symbols.
      '';

      valid_symbols =
        defaultNullOpts.mkListOf types.str
          [
            "File"
            "Module"
            "Namespace"
            "Package"
            "Class"
            "Method"
            "Property"
            "Field"
            "Constructor"
            "Enum"
            "Interface"
            "Function"
            "Variable"
            "Constant"
            "String"
            "Number"
            "Boolean"
            "Array"
            "Object"
            "Keyword"
            "Null"
            "EnumMember"
            "Struct"
            "Event"
            "Operator"
            "TypeParameter"
          ]
          ''
            A list of LSP document symbols to include in the results.
          '';

      request = {
        ttl_init = defaultNullOpts.mkUnsignedInt 60 ''
          Number of times to retry a request before giving up.
        '';

        interval = defaultNullOpts.mkUnsignedInt 1000 ''
          Number of milliseconds to wait between retries.
        '';
      };
    };

    markdown = {
      max_depth = defaultNullOpts.mkUnsignedInt 6 ''
        Maximum number of symbols to return.
      '';

      parse = {
        look_ahead = defaultNullOpts.mkUnsignedInt 200 ''
          Number of lines to update when cursor moves out of the parsed range.
        '';
      };
    };

    terminal = {
      icon =
        defaultNullOpts.mkStr
          (literalLua ''
            function(_)
              return M.opts.icons.kinds.symbols.Terminal or ' '
            end
          '')
          ''
            Icon to show before terminal names.
          '';

      name = defaultNullOpts.mkStr (literalLua "vim.api.nvim_buf_get_name") ''
        Name for the current terminal buffer.
      '';

      show_current = defaultNullOpts.mkBool true ''
        Show the current terminal buffer in the menu.
      '';
    };
  };
}
