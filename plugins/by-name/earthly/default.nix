{ lib, ... }:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "earthly";
  packPathName = "earthly.vim";
  package = "earthly-vim";
  url = "https://github.com/earthly/earthly.vim";
  description = "Earthfile syntax highlighting for vim";
  maintainers = [ lib.maintainers.DataHearth ];
}
