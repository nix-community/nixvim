{
  lib,
  helpers,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.colorschemes.poimandres;
in {
  options = {
    colorschemes.poimandres =
      helpers.extraOptionsOptions
      // {
        enable = mkEnableOption "poimandres";

        package = helpers.mkPackageOption "poimandres" pkgs.vimPlugins.poimandres-nvim;

        boldVertSplit = helpers.defaultNullOpts.mkBool false "bold vertical split";

        darkVariant = helpers.defaultNullOpts.mkStr "main" "dark variant";

        disableBackground = helpers.defaultNullOpts.mkBool false "Whether to disable the background.";

        disableFloatBackground =
          helpers.defaultNullOpts.mkBool false
          "Whether to disable the float background.";

        disableItalics = helpers.defaultNullOpts.mkBool false "Whether to disable italics.";

        dimNcBackground = helpers.defaultNullOpts.mkBool false "Dim NC background";

        groups =
          helpers.mkNullOrOption (with types; attrsOf (either str (attrsOf str)))
          "groups";

        highlightGroups = helpers.mkNullOrOption types.attrs "highlight groups";
      };
  };
  config = let
    setupOptions =
      {
        bold_vert_split = cfg.boldVertSplit;
        dark_variant = cfg.darkVariant;
        disable_background = cfg.disableBackground;
        disable_float_background = cfg.disableFloatBackground;
        disable_italics = cfg.disableItalics;
        dim_nc_background = cfg.dimNcBackground;
        inherit (cfg) groups;
        highlight_groups = cfg.highlightGroups;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      colorscheme = "poimandres";

      extraPlugins = [cfg.package];

      extraConfigLuaPre = ''
        require("poimandres").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
