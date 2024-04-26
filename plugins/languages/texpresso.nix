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

    maintainers = [maintainers.nickhu];

    extraOptions = {
      texpressoPackage = mkOption {
        type = with types; nullOr package;
        default = pkgs.texpresso;
        example = null;
        description = ''
          The `texpresso` package to use.
          Set to `null` to not install any package.
        '';
      };
    };

    extraConfig = cfg: {
      extraPackages = [cfg.texpressoPackage];
    };
  }
