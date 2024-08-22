{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
lib.nixvim.vim-plugin.mkVimPlugin config {
  name = "melange";
  isColorscheme = true;
  originalName = "melange-nvim";
  defaultPackage = pkgs.vimPlugins.melange-nvim;

  maintainers = [ maintainers.GaetanLepage ];

  extraConfig = cfg: { opts.termguicolors = mkDefault true; };
}
