{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "gitgutter";
  package = "vim-gitgutter";
  globalPrefix = "gitgutter_";
  description = "A Vim plugin which shows a git diff in the sign column.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [
    "git"
  ];

  imports = [
    # Added 2025-12-15, remove after 26.05
    (lib.mkRemovedOptionModule [ "plugins" "gitgutter" "grepPackage" ] ''
      Gitgutter no longer requires grep.
    '')
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
