{
  lib,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "melange";
  isColorscheme = true;
  originalName = "melange-nvim";
  package = "melange-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    opts.termguicolors = lib.mkDefault true;
  };
}
