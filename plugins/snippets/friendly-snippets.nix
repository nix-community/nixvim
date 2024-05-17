{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.friendly-snippets;
in
{
  meta.maintainers = [ maintainers.GaetanLepage ];

  options.plugins.friendly-snippets = {
    enable = mkEnableOption "friendly-snippets";

    package = helpers.mkPluginPackageOption "friendly-snippets" pkgs.vimPlugins.friendly-snippets;
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    # Simply add an element to the `fromVscode` list to trigger the import of friendly-snippets
    plugins.luasnip.fromVscode = [ { } ];
  };
}
