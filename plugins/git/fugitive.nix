{
  config,
  lib,
  helpers,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "fugitive";
  originalName = "vim-fugitive";
  defaultPackage = pkgs.vimPlugins.vim-fugitive;
  extraPackages = [pkgs.git];

  maintainers = [lib.maintainers.GaetanLepage];

  # In typical tpope fashion, this plugin has no config options
}
