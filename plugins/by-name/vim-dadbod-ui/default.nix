{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-dadbod-ui";
  description = "Simple UI for vim-dadbod.";
  maintainers = [ lib.maintainers.BoneyPatel ];
}
