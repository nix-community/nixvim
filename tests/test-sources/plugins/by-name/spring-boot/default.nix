{
  empty = {
    test.runNvim = false;

    plugins.spring-boot.enable = true;
  };

  defaults = {
    test.runNvim = false;

    plugins.spring-boot = {
      enable = true;

      settings = {
        ls_path = "/tmp/spring-boot-language-server.jar";
        jdtls_name = "jdtls";
        java_cmd = "/run/current-system/sw/bin/java";
        log_file = "/tmp/spring-boot-ls.log";
        server = {
          cmd = [
            "java"
            "-jar"
            "spring-boot-language-server.jar"
          ];
          root_dir.__raw = "vim.fs.root(0, { '.git', 'mvnw', 'gradlew' })";
        };
        autocmd = true;
      };
    };
  };
}
