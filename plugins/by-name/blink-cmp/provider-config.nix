lib:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
types.submodule {
  freeformType = with types; attrsOf anything;
  options = {
    name = defaultNullOpts.mkStr' {
      pluginDefault = null;
      description = ''
        The name of the source.
      '';
      example = "LSP";
    };

    module = defaultNullOpts.mkStr' {
      pluginDefault = null;
      description = ''
        The module name to load.
      '';
      example = "blink.cmp.sources.lsp";
    };

    enabled = defaultNullOpts.mkBool' {
      pluginDefault = true;
      description = ''
        Whether or not to enable the provider.
      '';
      example.__raw = ''
        function()
          return true
        end
      '';
    };

    opts = defaultNullOpts.mkAttrsOf types.anything null ''
      Options for this provider.
    '';

    async = defaultNullOpts.mkBool false ''
      Whether blink should wait for the source to return before showing the completions.
    '';

    timeout_ms = defaultNullOpts.mkUnsignedInt 2000 ''
      How long to wait for the provider to return before showing completions and treating it as
      asynchronous.
    '';

    transform_items = defaultNullOpts.mkRaw' {
      pluginDefault = ''function(_, items) return items end'';
      description = ''
        Function to transform the items before they're returned.
      '';
      example = ''
        function(_, items)
          -- demote snippets
          for _, item in ipairs(items) do
            if item.kind == require('blink.cmp.types').CompletionItemKind.Snippet then
              item.score_offset = item.score_offset - 3
            end
          end

          -- filter out text items, since we have the buffer source
          return vim.tbl_filter(
            function(item) return item.kind ~= require('blink.cmp.types').CompletionItemKind.Text end,
            items
          )
        end
      '';
    };

    should_show_items = defaultNullOpts.mkBool true ''
      Whether or not to show the items.
    '';

    max_items = defaultNullOpts.mkUnsignedInt null ''
      Maximum number of items to display in the menu.
    '';

    min_keyword_length = defaultNullOpts.mkUnsignedInt 0 ''
      Minimum number of characters in the keyword to trigger the provider.
    '';

    fallbacks = defaultNullOpts.mkListOf' {
      type = types.str;
      pluginDefault = [ ];
      description = ''
        If this provider returns `0` items, it will fallback to these providers.
      '';
      example = [ "buffer" ];
    };

    score_offset = defaultNullOpts.mkInt' {
      pluginDefault = 0;
      description = ''
        Boost/penalize the score of the items.
      '';
      example = 3;
    };

    deduplicate = defaultNullOpts.mkNullableWithRaw types.anything null ''
      Warning: not yet implemented.
    '';

    # https://github.com/Saghen/blink.cmp/blob/main/lua/blink/cmp/sources/lib/types.lua#L22
    override = defaultNullOpts.mkAttrsOf types.anything null ''
      Override source options.
    '';
  };
}
