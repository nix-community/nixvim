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
  addExtraConfigRenameWarning = true;
  extraPackages = [pkgs.ctags];
}
