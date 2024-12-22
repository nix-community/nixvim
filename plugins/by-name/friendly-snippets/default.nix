{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "friendly-snippets";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    # Simply add an element to the `fromVscode` list to trigger the import of friendly-snippets
    plugins.luasnip.fromVscode = [ { } ];
  };
}
