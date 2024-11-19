{
  lib,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "oxocarbon";
  isColorscheme = true;
  originalName = "oxocarbon.nvim";
  package = "oxocarbon-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    opts.termguicolors = lib.mkDefault true;
  };
}
