{
  lib,
  pkgs,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "dracula";
  originalName = "dracula.nvim ";
  defaultPackage = pkgs.vimPlugins.dracula-nvim;

  maintainers = [ lib.nixvim.maintainers.refaelsh ];

  settingsExample = {
    settings = {
      italic_comment = true;
      colors.green = "#00FF00";
    };
  };
}
