{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-dadbod-completion";
  description = "Database autocompletion powered by vim-dadbod.";
  maintainers = [ lib.maintainers.BoneyPatel ];
  imports = [
    { cmpSourcePlugins.vim-dadbod-completion = "vim-dadbod-completion"; }
  ];
}
