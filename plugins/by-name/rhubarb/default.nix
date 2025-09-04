{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "rhubarb";
  packPathName = "vim-rhubarb";
  package = "vim-fugitive";
  description = "Rhubarb is a GitHub extension for fugitive.vim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "git" ];

  imports = [
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "rhubarb";
      packageName = "git";
    })
  ];

}
