{
  lib,
  config,
  options,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "friendly-snippets";
  description = "Set of preconfigured snippets for different languages.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    warnings = lib.nixvim.mkWarnings "plugins.friendly-snippets" (
      let
        snippetConsumers = map (lib.splitString ".") [
          "plugins.luasnip.enable"
          "plugins.cmp.enable"
          "plugins.blink-cmp.enable"
          "plugins.nvim-snippets.enable"
        ];
        enabledConsumers = builtins.filter (
          consumerPath: lib.getAttrFromPath consumerPath config
        ) snippetConsumers;
        enabledConsumersPretty = lib.concatMapStringsSep ", " (
          consumerPath: lib.getAttrFromPath consumerPath options
        ) enabledConsumers;
      in
      {
        when =
          config.performance.combinePlugins.enable
          && !(builtins.elem "friendly-snippets" (
            map lib.getName config.performance.combinePlugins.standalonePlugins
          ))
          && (enabledConsumers != [ ]);
        message = ''
          When using ${options.performance.combinePlugins.enable}, ${options.plugins.friendly-snippets.enable} and ${enabledConsumersPretty}:
          "friendly-snippets" has to be added to ${options.performance.combinePlugins.standalonePlugins} in order to be picked up by the aforementioned plugins.
        '';
      }
    );
    # Simply add an element to the `fromVscode` list to trigger the import of friendly-snippets
    plugins.luasnip.fromVscode = [ { } ];
  };
}
