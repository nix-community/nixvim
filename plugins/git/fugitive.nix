{
  config,
  lib,
  helpers,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "fugitive";
  originalName = "vim-fugitive";
  defaultPackage = pkgs.vimPlugins.vim-fugitive;

  maintainers = [ lib.maintainers.GaetanLepage ];

  # In typical tpope fashion, this plugin has no config options
  extraOptions = {
    gitPackage = helpers.mkPackageOption {
      name = "git";
      default = pkgs.git;
    };
  };

  extraConfig = cfg: {
    extraPackages = [ cfg.gitPackage ];
  };
}
