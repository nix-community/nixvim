{
  helpers,
  config,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "tagbar";
  defaultPackage = pkgs.vimPlugins.tagbar;
  globalPrefix = "tagbar_";
  deprecateExtraConfig = true;
  extraPackages = [pkgs.ctags];
}
