{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
# This plugin has no configuration, so we use `mkVimPlugin` without the `globalPrefix` argument to
# avoid the creation of the `settings` option.
helpers.vim-plugin.mkVimPlugin config {
  name = "texpresso";
  originalName = "texpresso.vim";
  defaultPackage = pkgs.vimPlugins.texpresso-vim;

  maintainers = [ maintainers.nickhu ];

  extraOptions = {
    texpressoPackage = helpers.mkPackageOption {
      name = "texpresso";
      default = pkgs.texpresso;
    };
  };

  extraConfig = cfg: { extraPackages = [ cfg.texpressoPackage ]; };
}
