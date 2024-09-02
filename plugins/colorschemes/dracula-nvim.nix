{
  lib,
  config,
  pkgs,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin config {
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
