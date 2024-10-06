{ lib }:
let
  inherit (lib) mkOption types;
  inherit (lib.nixvim) defaultNullOpts;
in
{
  performance = {
    debounce = defaultNullOpts.mkUnsignedInt 60 ''
      Sets debounce time.
      This is the interval used to group up completions from different sources for filtering and
      displaying.
    '';

    throttle = defaultNullOpts.mkUnsignedInt 30 ''
      Sets throttle time.
      This is used to delay filtering and displaying completions.
    '';

    fetching_timeout = defaultNullOpts.mkUnsignedInt 500 ''
      Sets the timeout of candidate fetching process.
      The nvim-cmp will wait to display the most prioritized source.
    '';

    confirm_resolve_timeout = defaultNullOpts.mkUnsignedInt 80 ''
      Sets the timeout for resolving item before confirmation.
    '';

    async_budget = defaultNullOpts.mkUnsignedInt 1 ''
      Maximum time (in ms) an async function is allowed to run during one step of the event loop.
    '';

    max_view_entries = defaultNullOpts.mkUnsignedInt 200 ''
      Maximum number of items to show in the entries list.
    '';
  };

  preselect = defaultNullOpts.mkLua "cmp.PreselectMode.Item" ''
    - "cmp.PreselectMode.Item": nvim-cmp will preselect the item that the source specified.
    - "cmp.PreselectMode.None": nvim-cmp will not preselect any items.
  '';

  mapping = mkOption {
    default = { };
    type = with lib.types; maybeRaw (attrsOf strLua);
    description = ''
      cmp mappings declaration.
      See `:h cmp-mapping` for more information.
    '';
    example = {
      "<C-d>" = "cmp.mapping.scroll_docs(-4)";
      "<C-f>" = "cmp.mapping.scroll_docs(4)";
      "<C-Space>" = "cmp.mapping.complete()";
      "<C-e>" = "cmp.mapping.close()";
      "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
      "<CR>" = "cmp.mapping.confirm({ select = true })";
    };
  };

  snippet = {
    expand = mkOption {
      type = with lib.types; nullOr strLuaFn;
      default = null;
      description = ''
        The snippet expansion function. That's how nvim-cmp interacts with a particular snippet
        engine.


        Common engines:
        ```lua
          function(args)
            # vsnip
            vim.fn["vsnip#anonymous"](args.body)

            # luasnip
            require('luasnip').lsp_expand(args.body)

            # snippy
            require('snippy').expand_snippet(args.body)

            # ultisnips
            vim.fn["UltiSnips#Anon"](args.body)
          end
        ```

        You can also provide a custom function:
        ```lua
          function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end
        ```
      '';
      example = ''
        function(args)
          require('luasnip').lsp_expand(args.body)
        end
      '';
    };
  };

  completion = {
    keyword_length = defaultNullOpts.mkUnsignedInt 1 ''
      The number of characters needed to trigger auto-completion.
    '';

    keyword_pattern = defaultNullOpts.mkLua ''[[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]]'' "The default keyword pattern.";

    autocomplete =
      defaultNullOpts.mkNullable (with lib.types; either (enum [ false ]) (listOf strLua))
        [ "require('cmp.types').cmp.TriggerEvent.TextChanged" ]
        ''
          The event to trigger autocompletion.
          If set to `false`, then completion is only invoked manually (e.g. by calling `cmp.complete`).
        '';

    completeopt = defaultNullOpts.mkStr "menu,menuone,noselect" ''
      Like vim's completeopt setting.
      In general, you don't need to change this.
    '';
  };

  confirmation = {
    get_commit_characters =
      defaultNullOpts.mkLuaFn
        ''
          function(commit_characters)
            return commit_characters
          end
        ''
        ''
          You can append or exclude `commitCharacters` via this configuration option function.
          The `commitCharacters` are defined by the LSP spec.
        '';
  };

  formatting = {
    expandable_indicator = defaultNullOpts.mkBool true ''
      Boolean to show the `~` expandable indicator in cmp's floating window.
    '';

    fields =
      defaultNullOpts.mkListOf types.str
        [
          "abbr"
          "kind"
          "menu"
        ]
        ''
          An array of completion fields to specify their order.
        '';

    format =
      defaultNullOpts.mkLuaFn
        ''
          function(_, vim_item)
            return vim_item
          end
        ''
        ''
          `fun(entry: cmp.Entry, vim_item: vim.CompletedItem): vim.CompletedItem`

          The function used to customize the appearance of the completion menu.
          See `|complete-items|`.
          This value can also be used to modify the `dup` property.

          NOTE: The `vim.CompletedItem` can contain the special properties `abbr_hl_group`,
          `kind_hl_group` and `menu_hl_group`.
        '';
  };

  matching = {
    disallow_fuzzy_matching = defaultNullOpts.mkBool false ''
      Whether to allow fuzzy matching.
    '';

    disallow_fullfuzzy_matching = defaultNullOpts.mkBool false ''
      Whether to allow full-fuzzy matching.
    '';

    disallow_partial_fuzzy_matching = defaultNullOpts.mkBool true ''
      Whether to allow fuzzy matching without prefix matching.
    '';

    disallow_partial_matching = defaultNullOpts.mkBool false ''
      Whether to allow partial matching.
    '';

    disallow_prefix_unmatching = defaultNullOpts.mkBool false ''
      Whether to allow prefix unmatching.
    '';
  };

  sorting = {
    priority_weight = defaultNullOpts.mkUnsignedInt 2 ''
      Each item's original priority (given by its corresponding source) will be increased by
      `#sources - (source_index - 1)` and multiplied by `priority_weight`.

      That is, the final priority is calculated by the following formula:
      `final_score = orig_score + ((#sources - (source_index - 1)) * sorting.priority_weight)`
    '';

    comparators = mkOption {
      type = with lib.types; nullOr (listOf strLuaFn);
      default = null;
      description = ''
        The function to customize the sorting behavior.
        You can use built-in comparators via `cmp.config.compare.*`.

        Signature: `(fun(entry1: cmp.Entry, entry2: cmp.Entry): boolean | nil)[]`

        Default:
        ```nix
        [
          "require('cmp.config.compare').offset"
          "require('cmp.config.compare').exact"
          "require('cmp.config.compare').score"
          "require('cmp.config.compare').recently_used"
          "require('cmp.config.compare').locality"
          "require('cmp.config.compare').kind"
          "require('cmp.config.compare').length"
          "require('cmp.config.compare').order"
        ]
        ```
      '';
    };
  };

  sources = import ./sources-option.nix { inherit lib; };

  view = {
    entries =
      defaultNullOpts.mkNullable (with types; either str (attrsOf anything))
        {
          name = "custom";
          selection_order = "top_down";
        }
        ''
          The view class used to customize nvim-cmp's appearance.
        '';

    docs = {
      auto_open = defaultNullOpts.mkBool true ''
        Specify whether to show the docs_view when selecting an item.
      '';
    };
  };

  window =
    let
      mkWinhighlightOption =
        default:
        defaultNullOpts.mkStr default ''
          Specify the window's winhighlight option.
          See `|nvim_open_win|`.
        '';

      zindex = lib.nixvim.mkNullOrOption types.ints.unsigned ''
        The window's zindex.
        See `|nvim_open_win|`.
      '';
    in
    {
      completion = {
        border = defaultNullOpts.mkBorder (lib.genList (_: "") 8) "nvim-cmp completion popup menu" "";

        winhighlight = mkWinhighlightOption "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None";

        inherit zindex;

        scrolloff = defaultNullOpts.mkUnsignedInt 0 ''
          Specify the window's scrolloff option.
          See |'scrolloff'|.
        '';

        col_offset = defaultNullOpts.mkInt 0 ''
          Offsets the completion window relative to the cursor.
        '';

        side_padding = defaultNullOpts.mkUnsignedInt 1 ''
          The amount of padding to add on the completion window's sides.
        '';

        scrollbar = defaultNullOpts.mkBool true ''
          Whether the scrollbar should be enabled if there are more items that fit.
        '';
      };

      documentation = {
        border = defaultNullOpts.mkBorder (lib.genList (_: "") 8) "nvim-cmp documentation popup menu" "";

        winhighlight = mkWinhighlightOption "FloatBorder:NormalFloat";

        inherit zindex;

        max_width = lib.nixvim.mkNullOrStrLuaOr types.ints.unsigned ''
          The documentation window's max width.

          Default: "math.floor((40 * 2) * (vim.o.columns / (40 * 2 * 16 / 9)))"
        '';

        max_height = lib.nixvim.mkNullOrStrLuaOr types.ints.unsigned ''
          The documentation window's max height.

          Default: "math.floor(40 * (40 / vim.o.lines))"
        '';
      };
    };

  # This can be kept as types.attrs since experimental features are often removed or completely
  # changed after a while
  experimental = lib.nixvim.mkNullOrOption (with types; attrsOf anything) ''
    Experimental features.
  '';
}
