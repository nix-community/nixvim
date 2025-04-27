{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "fugitive";
  packPathName = "vim-fugitive";
  package = "vim-fugitive";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "git" ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "fugitive";
      packageName = "git";
    })
  ];

  # In typical tpope fashion, this plugin has no config options
}
