{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-css-color";
  maintainers = [ lib.maintainers.DanielLaing ];
}
