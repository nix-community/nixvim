{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "spring-boot";
  moduleName = "spring_boot";
  package = "spring-boot-nvim";
  description = "Spring Boot support for Neovim, including STS4 language server integration.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    java_cmd = "/run/current-system/sw/bin/java";
    log_file = "/tmp/spring-boot-ls.log";
    server = {
      root_dir.__raw = "vim.fs.root(0, { '.git', 'mvnw', 'gradlew' })";
    };
    autocmd = true;
  };
}
