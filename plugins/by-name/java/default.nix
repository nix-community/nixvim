{ lib, config, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "java";
  packPathName = "nvim-java";
  package = "nvim-java";
  description = "Neovim plugin for Java development, providing LSP support and more.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # `require("java").setup()` must run **BEFORE** lspconfig
  configLocation = lib.mkOrder 900 "extraConfigLua";

  settingsOptions = {
    root_markers =
      defaultNullOpts.mkListOf types.str
        [
          "settings.gradle"
          "settings.gradle.kts"
          "pom.xml"
          "build.gradle"
          "mvnw"
          "gradlew"
          "build.gradle"
          "build.gradle.kts"
          ".git"
        ]
        ''
          List of files that exist in root of the project.
        '';
  };

  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "plugins.nvim-java" {
      assertion = cfg.enable -> !config.plugins.jdtls.enable;
      message = ''
        You cannot use nvim-java alongside nvim-jdtls.
        Please, disable `plugins.jdtls` if you wish to use this plugin.
      '';
    };
  };
}
