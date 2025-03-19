{
  lib,
  pkgs,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "typst-preview";
  packPathName = "typst-preview.nvim";
  package = "typst-preview-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions = {
    tinymistPackage = lib.mkPackageOption pkgs "tinymist" {
      nullable = true;
    };
    websocatPackage = lib.mkPackageOption pkgs "websocat" {
      nullable = true;
    };
  };
  extraConfig = cfg: {
    extraPackages = [
      cfg.tinymistPackage
      cfg.websocatPackage
    ];

    plugins.typst-preview.settings = {
      # Disable automatic downloading of binary dependencies
      dependencies_bin = {
        tinymist = lib.mkIf (cfg.tinymistPackage != null) (lib.mkDefault (lib.getExe cfg.tinymistPackage));
        websocat = lib.mkIf (cfg.websocatPackage != null) (lib.mkDefault (lib.getExe cfg.websocatPackage));
      };
    };
  };

  settingsExample = {
    debug = true;
    port = 8000;
    dependencies_bin = {
      tinymist = "tinymist";
      websocat = "websocat";
    };
  };
}
