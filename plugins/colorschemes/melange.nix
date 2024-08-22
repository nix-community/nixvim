{
  lib,
  config,
  pkgs,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin config {
  name = "melange";
  isColorscheme = true;
  originalName = "melange-nvim";
  defaultPackage = pkgs.vimPlugins.melange-nvim;

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = cfg: { opts.termguicolors = lib.mkDefault true; };
}
