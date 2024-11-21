{ lib, ... }:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "vim-colemak";
  maintainers = [ lib.maintainers.kalbasit ];
}
