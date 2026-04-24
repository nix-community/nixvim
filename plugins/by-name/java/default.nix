{ lib, config, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "java";
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

    warnings = lib.nixvim.mkWarnings "plugins.java" {
      when = !(cfg.settings ? spring_boot_tools) && !config.plugins.spring-boot.enable;
      message = ''
        `nvim-java` enables `spring_boot_tools` by default, but `plugins.spring-boot` is not enabled.
        Enable `plugins.spring-boot` or explicitly configure `plugins.java.settings.spring_boot_tools`
        to silence this warning.
      '';
    };
  };
}
