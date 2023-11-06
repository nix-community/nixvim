{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.colorschemes.rose-pine;
in {
  options = {
    colorschemes.rose-pine = {
      enable = mkEnableOption "rose-pine";

      package = helpers.mkPackageOption "rose-pine" pkgs.vimPlugins.rose-pine;

      style = helpers.defaultNullOpts.mkEnumFirstDefault ["main" "moon" "dawn"] "Theme style";

      boldVerticalSplit = helpers.defaultNullOpts.mkBool false "Bolds vertical splits";

      dimInactive = helpers.defaultNullOpts.mkBool false "Dims inactive windows";

      disableItalics = helpers.defaultNullOpts.mkBool false "Disables italics";

      groups = helpers.mkNullOrOption types.attrs "rose-pine highlight groups";

      highlightGroups = helpers.mkNullOrOption types.attrs "Custom highlight groups";

      transparentBackground = helpers.defaultNullOpts.mkBool false "Disable setting background";

      transparentFloat = helpers.defaultNullOpts.mkBool false "Disable setting background for floating windows";
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "rose-pine";
    extraPlugins = [cfg.package];
    options = {termguicolors = true;};
    extraConfigLuaPre = let
      setupOptions = with cfg; {
        inherit groups;
        dark_variant = style;
        bold_vert_split = boldVerticalSplit;
        disable_background = transparentBackground;
        disable_float_background = transparentFloat;
        disable_italics = disableItalics;
        dim_nc_background = dimInactive;
        highlight_groups = highlightGroups;
      };
    in ''
      require("rose-pine").setup(${helpers.toLuaObject setupOptions})
    '';
  };
}
