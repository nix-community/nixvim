lib:
let
  inherit (lib) types;
  inherit (lib.nixvim)
    mkNullOrOption
    mkNullOrStr'
    mkNullOrOption'
    ;
in
types.submodule {
  freeformType = with types; attrsOf anything;
  options = {
    name = mkNullOrStr' {
      description = ''
        The name of the source.
      '';
      example = "LSP";
    };

    module = mkNullOrStr' {
      description = ''
        The module name to load.
      '';
      example = "blink.cmp.sources.lsp";
    };

    enabled = mkNullOrOption' {
      type = types.bool;
      description = ''
        Whether or not to enable the provider.
      '';
      example.__raw = ''
        function()
          return true
        end
      '';
    };

    opts = mkNullOrOption' {
      type = with types; attrsOf anything;
      description = ''
        Options for this provider.
      '';
      example = { };
    };

    async = mkNullOrOption types.bool ''
      Whether blink should wait for the source to return before showing the completions.
    '';

    timeout_ms = mkNullOrOption types.ints.unsigned ''
      How long to wait for the provider to return before showing completions and treating it as
      asynchronous.
    '';

    transform_items = mkNullOrOption' {
      type = types.rawLua;
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

    should_show_items = mkNullOrOption types.bool ''
      Whether or not to show the items.
    '';

    max_items = mkNullOrOption types.ints.unsigned ''
      Maximum number of items to display in the menu.
    '';

    min_keyword_length = mkNullOrOption types.ints.unsigned ''
      Minimum number of characters in the keyword to trigger the provider.
    '';

    fallbacks = mkNullOrOption' {
      type = with types; listOf str;
      description = ''
        If this provider returns `0` items, it will fallback to these providers.
      '';
      example = [ "buffer" ];
    };

    score_offset = mkNullOrOption' {
      type = types.int;
      description = ''
        Boost/penalize the score of the items.
      '';
      example = 3;
    };

    deduplicate = mkNullOrOption types.anything ''
      Warning: not yet implemented.
    '';

    # https://github.com/Saghen/blink.cmp/blob/main/lua/blink/cmp/sources/lib/types.lua#L22
    override = mkNullOrOption (with types; attrsOf anything) ''
      Override source options.
    '';
  };
}
