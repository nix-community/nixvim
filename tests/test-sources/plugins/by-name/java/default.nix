{
  empty = {
    # Tries to write to a log file
    test.runNvim = false;

    plugins.java.enable = true;

    test.warnings = expect: [
      (expect "count" 1)
      (expect "any" "`nvim-java` enables `spring_boot_tools` by default")
      (expect "any" "`plugins.spring-boot` is not enabled")
    ];
  };

  defaults = {
    # Tries to write to a log file
    test.runNvim = false;

    plugins.java = {
      enable = true;

      settings = {
        root_markers = [
          "settings.gradle"
          "settings.gradle.kts"
          "pom.xml"
          "build.gradle"
          "mvnw"
          "gradlew"
          "build.gradle"
          "build.gradle.kts"
          ".git"
        ];
        jdtls = {
          version = "v1.43.0";
        };
        lombok = {
          version = "nightly";
        };
        java_test = {
          enable = true;
          version = "0.40.1";
        };
        java_debug_adapter = {
          enable = true;
          version = "0.58.1";
        };
        spring_boot_tools = {
          enable = true;
          version = "1.55.1";
        };
        jdk = {
          auto_install = true;
          version = "17.0.2";
        };
        notifications = {
          dap = true;
        };
        verification = {
          invalid_order = true;
          duplicate_setup_calls = true;
          invalid_mason_registry = false;
        };
      };
    };

    test.warnings = expect: [
      (expect "count" 0)
    ];
  };

  explicit-disable-spring-boot-tools = {
    # Tries to write to a log file
    test.runNvim = false;

    plugins.java = {
      enable = true;
      settings.spring_boot_tools.enable = false;
    };

    test.warnings = expect: [
      (expect "count" 0)
    ];
  };

  with-spring-boot-plugin = {
    # Tries to write to a log file
    test.runNvim = false;

    plugins = {
      java.enable = true;
      spring-boot.enable = true;
    };

    test.warnings = expect: [
      (expect "count" 0)
    ];
  };
}
