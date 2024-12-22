{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-colemak";
  maintainers = [ lib.maintainers.kalbasit ];
}
