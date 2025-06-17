{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-dadbod";
  description = "Modern database interface for Vim.";
  maintainers = [ lib.maintainers.BoneyPatel ];
}
