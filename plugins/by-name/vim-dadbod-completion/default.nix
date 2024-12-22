{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-dadbod-completion";
  maintainers = [ lib.maintainers.BoneyPatel ];
  imports = [
    { cmpSourcePlugins.vim-dadbod-completion = "vim-dadbod-completion"; }
  ];
}
