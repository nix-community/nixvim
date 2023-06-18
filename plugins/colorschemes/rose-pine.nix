{
  pkgs,
  config,
  lib,
  ...
} @ args:
with lib; let
  cfg = config.colorschemes.rose-pine;
  helpers = import ../helpers.nix args;
in {
  options = {
    colorschemes.rose-pine = {
      enable = mkEnableOption "rosepine";
      package = helpers.mkPackageOption "rosepine" pkgs.vimPlugins.rose-pine;
      style = helpers.defaultNullOpts.mkEnumFirstDefault ["main" "moon" "dawn"] "Theme style";

      boldVerticalSplit = helpers.defaultNullOpts.mkBool false "Bolds vertical splits";
      dimInactive = helpers.defaultNullOpts.mkBool false "Dims inactive windows";
      disableItalics = helpers.defaultNullOpts.mkBool false "Disables italics";

      groups = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = "rose-pine highlight groups";
      };

      highlightGroups = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = "Custom highlight groups";
      };

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
        inherit (cfg) groups;
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
