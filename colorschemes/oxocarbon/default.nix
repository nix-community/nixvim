{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "oxocarbon";
  isColorscheme = true;
  package = "oxocarbon-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    opts.termguicolors = lib.mkDefault true;
  };
}
