{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-colemak";
  description = "Colemak key mappings for Vim.";
  maintainers = [ lib.maintainers.kalbasit ];
}
