{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-dadbod";
  maintainers = [ lib.maintainers.BoneyPatel ];
}
