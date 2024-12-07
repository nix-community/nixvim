{ lib, ... }:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "vim-dadbod";
  maintainers = [ lib.maintainers.BoneyPatel ];
}
