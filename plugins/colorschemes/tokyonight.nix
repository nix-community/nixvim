{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.colorschemes.tokyonight;
  style = types.enum [ "storm" "night" "day" ];
in {
  options = {
    programs.nixvim.colorschemes.tokyonight = {
      enable = mkEnableOption "Enable tokyonight";
      style = mkOption {
        type = types.nullOr style;
        default = null;
        description = "Theme style";
      };
      terminalColors = mkEnableOption
        "Configure the colors used when opening a :terminal in Neovim";
      italicComments = mkEnableOption "Make comments italic";
      italicKeywods = mkEnableOption "Make keywords italic";
      italicFunctions = mkEnableOption "Make functions italic";
      italicVariables = mkEnableOption "Make variables and identifiers italic";
      transparent =
        mkEnableOption "Enable this to disable setting the background color";
      hideInactiveStatusline = mkEnableOption
        "Enabling this option will hide inactive statuslines and replace them with a thin border";
      transparentSidebar = mkEnableOption
        "Sidebar like windows like NvimTree get a transparent background";
      darkSidebar = mkEnableOption
        "Sidebar like windows like NvimTree get a darker background";
      darkFloat = mkEnableOption
        "Float windows like the lsp diagnostics windows get a darker background";
      lualineBold = mkEnableOption
        "When true, section headers in the lualine theme will be bold";
    };
  };
  config = mkIf cfg.enable {
    programs.nixvim = {
      colorscheme = "tokyonight";
      extraPlugins = [ pkgs.vimPlugins.tokyonight-nvim ];
      options = { termguicolors = true; };
      globals = {
        tokyonight_style = mkIf (!isNull cfg.style) cfg.style;
        tokyonight_terminal_colors = mkIf (!cfg.terminalColors) 0;

        tokyonight_italic_comments = mkIf (!cfg.italicComments) 0;
        tokyonight_italic_keywords = mkIf (!cfg.italicKeywods) 0;
        tokyonight_italic_functions = mkIf (cfg.italicFunctions) 1;
        tokyonight_italic_variables = mkIf (cfg.italicVariables) 1;

        tokyonight_transparent = mkIf (cfg.transparent) 1;
        tokyonight_hide_inactive_statusline =
          mkIf (cfg.hideInactiveStatusline) 1;
        tokyonight_transparent_sidebar = mkIf (cfg.transparentSidebar) 1;
        tokyonight_dark_sidebar = mkIf (!cfg.darkSidebar) 0;
        tokyonight_dark_float = mkIf (!cfg.darkFloat) 0;
        tokyonight_lualine_bold = mkIf (cfg.lualineBold) 1;
      };
    };
  };
}
