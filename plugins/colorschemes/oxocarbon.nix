{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "oxocarbon";
  isColorscheme = true;
  originalName = "oxocarbon.nvim";
  defaultPackage = pkgs.vimPlugins.oxocarbon-nvim;

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = cfg: { opts.termguicolors = lib.mkDefault true; };
}
