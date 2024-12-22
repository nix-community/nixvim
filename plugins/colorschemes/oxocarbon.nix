{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "oxocarbon";
  isColorscheme = true;
  packPathName = "oxocarbon.nvim";
  package = "oxocarbon-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    opts.termguicolors = lib.mkDefault true;
  };
}
