{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.colorschemes.tokyonight;
  style = types.enum [ "storm" "night" "day" ];
  helpers = import ../helpers.nix { inherit lib; };
in
{
  options = {
    colorschemes.tokyonight = {
      enable = mkEnableOption "Enable tokyonight";
      package = mkOption {
        type = types.package;
        default = pkgs.vimPlugins.tokyonight-nvim;
        description = "Plugin to use for tokyonight";
      };
      style = mkOption {
        type = style;
        default = "storm";
        description = "Theme style";
      };
      terminalColors = mkOption {
        type = types.bool;
        default = true;
        description = "Configure the colors used when opening a :terminal in Neovim";
      };
      transparent =
        mkEnableOption "Enable this to disable setting the background color";
      styles =
        let
          mkBackgroundStyle = name: mkOption {
            type = types.enum [ "dark" "transparent" "normal" ];
            description = "Background style for ${name}";
            default = "dark";
          };
        in
        {
          comments = mkOption {
            type = types.attrsOf types.anything;
            description = "Define comments highlight properties";
            default = { italic = true; };
          };
          keywords = mkOption {
            type = types.attrsOf types.anything;
            description = "Define keywords highlight properties";
            default = { italic = true; };
          };
          functions = mkOption {
            type = types.attrsOf types.anything;
            description = "Define functions highlight properties";
            default = { };
          };
          variables = mkOption {
            type = types.attrsOf types.anything;
            description = "Define variables highlight properties";
            default = { };
          };
          sidebars = mkBackgroundStyle "sidebars";
          floats = mkBackgroundStyle "floats";
        };
      sidebars = mkOption {
        type = types.listOf types.str;
        default = [ "qf" "help" ];
        description = "Set a darker background on sidebar-like windows";
        example = ''["qf" "vista_kind" "terminal" "packer"]'';
      };
      dayBrightness = mkOption {
        type = types.numbers.between 0.0 1.0;
        default = 0.3;
        description = "Adjusts the brightness of the colors of the **Day** style";
      };
      hideInactiveStatusline =
        mkEnableOption
          "Enabling this option will hide inactive statuslines and replace them with a thin border";
      dimInactive = mkEnableOption "dims inactive windows";
      lualineBold =
        mkEnableOption
          "When true, section headers in the lualine theme will be bold";
    };
  };
  config = mkIf cfg.enable {
    colorscheme = "tokyonight";
    extraPlugins = [ cfg.package ];
    options = { termguicolors = true; };
    extraConfigLuaPre =
      let
        setupOptions = with cfg; {
          inherit (cfg) style transparent styles sidebars;
          terminal_colors = terminalColors;
          hide_inactive_statusline = hideInactiveStatusline;
          dim_inactive = dimInactive;
          lualine_bold = lualineBold;
          day_brightness = dayBrightness;
        };
      in
      ''
        require("tokyonight").setup(${helpers.toLuaObject setupOptions})
      '';
  };
}
