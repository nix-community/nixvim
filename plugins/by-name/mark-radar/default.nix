{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.mark-radar;
in
{
  options.plugins.mark-radar = lib.nixvim.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "mark-radar";

    package = lib.mkPackageOption pkgs "mark-radar" {
      default = [
        "vimPlugins"
        "mark-radar-nvim"
      ];
    };

    setDefaultMappings = helpers.defaultNullOpts.mkBool true "Whether to set default mappings.";

    highlightGroup = helpers.defaultNullOpts.mkStr "RadarMark" "The name of the highlight group to use.";

    backgroundHighlight = helpers.defaultNullOpts.mkBool true "Whether to highlight the background.";

    backgroundHighlightGroup = helpers.defaultNullOpts.mkStr "RadarBackground" "The name of the highlight group to use for the background.";
  };

  config =
    let
      setupOptions = {
        set_default_mappings = cfg.setDefaultMappings;
        highlight_group = cfg.highlightGroup;
        background_highlight = cfg.backgroundHighlight;
        background_highlight_group = cfg.backgroundHighlightGroup;
      } // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require("mark-radar").setup(${lib.nixvim.toLuaObject setupOptions})
      '';
    };
}
