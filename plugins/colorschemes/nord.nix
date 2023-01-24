{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.colorschemes.nord;
in
{
  options = {
    colorschemes.nord = {
      enable = mkEnableOption "nord";

      package = mkOption {
        type = types.package;
        default = pkgs.vimPlugins.nord-nvim;
        description = "Plugin to use for nord.nvim";
      };

      contrast = mkEnableOption
        "Make sidebars and popup menus like nvim-tree and telescope have a different background";

      borders = mkEnableOption
        "Enable the border between verticaly split windows visable";

      disable_background = mkEnableOption
        "Disable the setting of background color so that NeoVim can use your terminal background";

      cursorline_transparent = mkEnableOption
        "Set the cursorline transparent/visible";

      enable_sidebar_background = mkEnableOption
        "Re-enables the background of the sidebar if you disabled the background of everything";

      italic = mkOption {
        description = "enables/disables italics";
        type = types.nullOr types.bool;
        default = null;
      };
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "nord";
    extraPlugins = [ cfg.package ];

    globals = {
      nord_contrast = mkIf cfg.contrast 1;
      nord_borders = mkIf cfg.borders 1;
      nord_disable_background = mkIf cfg.disable_background 1;
      nord_cursoline_transparent = mkIf cfg.cursorline_transparent 1;
      nord_enable_sidebar_background = mkIf cfg.enable_sidebar_background 1;
      nord_italic = mkIf (cfg.italic != null) cfg.italic;
    };
  };
}
