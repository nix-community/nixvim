{
  config,
  helpers,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "fugitive";
  originalName = "vim-fugitive";
  package = pkgs.vimPlugins.vim-fugitive;
  extraPackages = [pkgs.git];

  # In typical tpope fashion, this plugin has no config options
  options = {};
}
