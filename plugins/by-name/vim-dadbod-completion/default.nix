{ lib, ... }:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "vim-dadbod-completion";
  maintainers = [ lib.maintainers.BoneyPatel ];
  imports = [
    { cmpSourcePlugins.vim-dadbod-completion = "vim-dadbod-completion"; }
  ];
}
