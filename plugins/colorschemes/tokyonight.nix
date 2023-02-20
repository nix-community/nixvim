{
  pkgs,
  config,
  lib,
  ...
} @ args:
with lib; let
  cfg = config.colorschemes.tokyonight;
  helpers = import ../helpers.nix args;
in {
  options = {
    colorschemes.tokyonight = {
      enable = mkEnableOption "tokyonight";
      package = helpers.mkPackageOption "tokyonight" pkgs.vimPlugins.tokyonight-nvim;
      style = helpers.defaultNullOpts.mkEnumFirstDefault ["storm" "night" "day"] "Theme style";
      terminalColors =
        helpers.defaultNullOpts.mkBool true
        "Configure the colors used when opening a :terminal in Neovim";
      transparent = helpers.defaultNullOpts.mkBool false "disable setting the background color";
      styles = let
        mkBackgroundStyle = name:
          helpers.defaultNullOpts.mkEnumFirstDefault ["dark" "transparent" "normal"]
          "Background style for ${name}";
      in {
        comments =
          helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) "{italic = true;}"
          "Define comments highlight properties";
        keywords =
          helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) "{italic = true;}"
          "Define keywords highlight properties";
        functions =
          helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) "{}"
          "Define functions highlight properties";
        variables =
          helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) "{}"
          "Define variables highlight properties";
        sidebars = mkBackgroundStyle "sidebars";
        floats = mkBackgroundStyle "floats";
      };
      sidebars =
        helpers.defaultNullOpts.mkNullable (types.listOf types.str) ''["qf" "help"]''
        "Set a darker background on sidebar-like windows";
      dayBrightness =
        helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) "0.3"
        "Adjusts the brightness of the colors of the **Day** style";
      hideInactiveStatusline =
        helpers.defaultNullOpts.mkBool false
        "Enabling this option will hide inactive statuslines and replace them with a thin border";
      dimInactive = helpers.defaultNullOpts.mkBool false "dims inactive windows";
      lualineBold =
        helpers.defaultNullOpts.mkBool false
        "When true, section headers in the lualine theme will be bold";
    };
  };
  config = mkIf cfg.enable {
    colorscheme = "tokyonight";
    extraPlugins = [cfg.package];
    options = {termguicolors = true;};
    extraConfigLuaPre = let
      setupOptions = with cfg; {
        inherit (cfg) style transparent styles sidebars;
        terminal_colors = terminalColors;
        hide_inactive_statusline = hideInactiveStatusline;
        dim_inactive = dimInactive;
        lualine_bold = lualineBold;
        day_brightness = dayBrightness;
      };
    in ''
      require("tokyonight").setup(${helpers.toLuaObject setupOptions})
    '';
  };
}
