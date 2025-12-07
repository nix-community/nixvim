{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "typst-preview";
  package = "typst-preview-nvim";
  description = "A Neovim plugin for previewing Typst documents in a web browser, with support for live reloading.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [
    "tinymist"
    "websocat"
  ];

  extraConfig = cfg: {
    plugins.typst-preview.settings = {
      # Disable automatic downloading of binary dependencies
      dependencies_bin = {
        tinymist = lib.mkIf config.dependencies.tinymist.enable (
          lib.mkDefault (lib.getExe config.dependencies.tinymist.package)
        );
        websocat = lib.mkIf config.dependencies.websocat.enable (
          lib.mkDefault (lib.getExe config.dependencies.websocat.package)
        );
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
