{
  lib,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "onedark";
  isColorscheme = true;
  originalName = "onedark.nvim";
  package = "onedark-nvim";

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
    colorschemes.onedark.luaConfig.content = ''
      _onedark = require('onedark')
      _onedark.setup(${lib.nixvim.toLuaObject cfg.settings})
      _onedark.load()
    '';
  };
}
