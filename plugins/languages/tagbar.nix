{
  helpers,
  config,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "tagbar";
  package = pkgs.vimPlugins.tagbar;
  globalPrefix = "tagbar_";
  extraPackages = [pkgs.ctags];
}
