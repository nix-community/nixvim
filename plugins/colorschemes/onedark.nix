{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "onedark";
  isColorscheme = true;
  originalName = "onedark.nvim";
  defaultPackage = pkgs.vimPlugins.onedark-nvim;

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    colors = {
      bright_orange = "#ff8800";
      green = "#00ffaa";
    };
    highlights = {
      "@keyword".fg = "$green";
      "@string" = {
        fg = "$bright_orange";
        bg = "#00ff00";
        fmt = "bold";
      };
      "@function" = {
        fg = "#0000ff";
        sp = "$cyan";
        fmt = "underline,italic";
      };
      "@function.builtin".fg = "#0059ff";
    };
  };

  callSetup = false;
  colorscheme = null;
  extraConfig = cfg: {
    extraConfigLuaPre = ''
      _onedark = require('onedark')
      _onedark.setup(${helpers.toLuaObject cfg.settings})
      _onedark.load()
    '';
  };
}
