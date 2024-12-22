{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-dadbod-ui";
  maintainers = [ lib.maintainers.BoneyPatel ];
}
