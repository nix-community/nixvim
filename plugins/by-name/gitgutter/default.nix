{
  lib,
  pkgs,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "gitgutter";
  package = "vim-gitgutter";
  globalPrefix = "gitgutter_";
  description = "A Vim plugin which shows a git diff in the sign column.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "git" ];

  extraOptions = {
    recommendedSettings = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Set recommended neovim option.
      '';
    };

    grepPackage = lib.mkPackageOption pkgs "gnugrep" {
      nullable = true;
    };
  };

  extraConfig = cfg: {
    opts = lib.optionalAttrs cfg.recommendedSettings {
      updatetime = 100;
      foldtext = "gitgutter#fold#foldtext";
    };

    extraPackages = [
      cfg.grepPackage
    ];
  };

  settingsExample = {
    set_sign_backgrounds = true;
    sign_modified_removed = "*";
    sign_priority = 20;
    preview_win_floating = true;
  };
}
