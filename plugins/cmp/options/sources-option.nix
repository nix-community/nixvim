{ lib, helpers }:
with lib;
let
  sourceType = types.submodule {
    freeformType = with types; attrsOf anything;
    options = {
      name = mkOption {
        type = types.str;
        description = "The name of the source.";
        example = "buffer";
      };

      option = helpers.mkNullOrOption (with types; attrsOf anything) ''
        Any specific options defined by the source itself.

        If direct lua code is needed use `helpers.mkRaw`.
      '';

      keyword_length = helpers.mkNullOrOption types.ints.unsigned ''
        The source-specific keyword length to trigger auto completion.
      '';

      keyword_pattern = helpers.mkNullOrLua ''
        The source-specific keyword pattern.
      '';

      trigger_characters = helpers.mkNullOrOption (with types; listOf str) ''
        Trigger characters.
      '';

      priority = helpers.mkNullOrOption types.ints.unsigned ''
        The source-specific priority value.
      '';

      group_index = helpers.mkNullOrOption types.ints.unsigned ''
        The source group index.

        For instance, you can set the `buffer`'s source `group_index` to a larger number
        if you don't want to see `buffer` source items while `nvim-lsp` source is available:

        ```nix
          sources = [
            {
              name = "nvim_lsp";
              group_index = 1;
            }
            {
              name = "buffer";
              group_index = 2;
            }
          ];
        ```
      '';

      entry_filter = helpers.mkNullOrLuaFn ''
        A source-specific entry filter, with the following function signature:

        `function(entry: cmp.Entry, ctx: cmp.Context): boolean`

        Returning `true` will keep the entry, while returning `false` will remove it.

        This can be used to hide certain entries from a given source. For instance, you
        could hide all entries with kind `Text` from the `nvim_lsp` filter using the
        following source definition:

        ```nix
        {
          name = "nvim_lsp";
          entry_filter = \'\'
            function(entry, ctx)
              return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
            end
          \'\';
        }
        ```

        Using the `ctx` parameter, you can further customize the behaviour of the source.
      '';
    };
  };
in
mkOption {
  default = [ ];
  type = with lib.types; maybeRaw (listOf sourceType);
  description = ''
    The sources to use.
    Can either be a list of `sourceConfigs` which will be made directly to a Lua object.
    Or it can be a raw lua string which might be necessary for more advanced use cases.

    WARNING:
    If `plugins.cmp.autoEnableSources` Nixivm will automatically enable the corresponding source
    plugins. This will work only when this option is set to a list.
    If you use a raw lua string, you will need to explicitly enable the relevant source plugins in
    your nixvim configuration.
  '';
  example = [
    { name = "nvim_lsp"; }
    { name = "luasnip"; }
    { name = "path"; }
    { name = "buffer"; }
  ];
}
