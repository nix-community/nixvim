{
  lib,
  helpers,
  ...
}:
helpers.vim-plugin.mkVimPlugin {
  name = "vim-css-color";
  maintainers = [ lib.maintainers.DanielLaing ];
}
