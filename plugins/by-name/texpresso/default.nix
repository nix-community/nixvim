{
  lib,
  ...
}:
with lib;
# This plugin has no configuration, so we use `mkVimPlugin` without the `globalPrefix` argument to
# avoid the creation of the `settings` option.
lib.nixvim.plugins.mkVimPlugin {
  name = "texpresso";
  packPathName = "texpresso.vim";
  package = "texpresso-vim";

  maintainers = [ maintainers.nickhu ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "texpresso";
      packageName = "texpresso";
    })
  ];

  extraConfig = {
    dependencies.texpresso.enable = lib.mkDefault true;
  };
}
