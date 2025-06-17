{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-css-color";
  description = "Preview CSS colors in Vim.";
  maintainers = [ lib.maintainers.DanielLaing ];
}
