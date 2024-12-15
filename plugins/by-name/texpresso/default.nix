{
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
# This plugin has no configuration, so we use `mkVimPlugin` without the `globalPrefix` argument to
# avoid the creation of the `settings` option.
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "texpresso";
  packPathName = "texpresso.vim";
  package = "texpresso-vim";

  maintainers = [ maintainers.nickhu ];

  extraOptions = {
    texpressoPackage = lib.mkPackageOption pkgs "texpresso" {
      nullable = true;
    };
  };

  extraConfig = cfg: { extraPackages = [ cfg.texpressoPackage ]; };
}
