{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "gitgutter";
  package = "vim-gitgutter";
  globalPrefix = "gitgutter_";
  description = "A Vim plugin which shows a git diff in the sign column.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [
    "git"
    "grep"
  ];

  imports = [
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "gitgutter";
      packageName = "grep";
    })
  ];

  extraOptions = {
    recommendedSettings = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Set recommended neovim option.
      '';
    };
  };

  extraConfig = cfg: {
    opts = lib.optionalAttrs cfg.recommendedSettings {
      updatetime = 100;
      foldtext = "gitgutter#fold#foldtext";
    };
  };

  settingsExample = {
    set_sign_backgrounds = true;
    sign_modified_removed = "*";
    sign_priority = 20;
    preview_win_floating = true;
  };
}
