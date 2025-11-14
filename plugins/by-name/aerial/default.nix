{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "aerial";
  package = "aerial-nvim";
  description = "A code outline window for skimming and quick navigation.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    on_attach = defaultNullOpts.mkRaw "function(bufnr) end" ''
      Call this function when aerial attaches to a buffer.
    '';

    on_first_symbols = defaultNullOpts.mkRaw "function(bufnr) end" ''
      Call this function when aerial first sets symbols on a buffer.
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
