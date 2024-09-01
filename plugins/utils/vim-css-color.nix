{
  helpers,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin {
  name = "vim-css-color";
  defaultPackage = pkgs.vimPlugins.vim-css-color;

  maintainers = [ helpers.maintainers.DanielLaing ];
}
