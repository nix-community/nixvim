{ lib, ... }:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "vim-dadbod-ui";
  maintainers = [ lib.maintainers.BoneyPatel ];
}
