{
  lib,
  pkgs,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "dracula-nvim";
  originalName = "dracula.nvim ";
  luaName = "dracula";
  colorscheme = "dracula";
  defaultPackage = pkgs.vimPlugins.dracula-nvim;
  isColorscheme = true;

  maintainers = [ lib.nixvim.maintainers.refaelsh ];

  settingsExample = {
    italic_comment = true;
    colors.green = "#00FF00";
  };
}
