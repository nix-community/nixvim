{ pkgs, ... }:
{
  example = {
    plugins.nvim-jdtls = {
      enable = true;
      jdtLanguageServerPackage = null;
      cmd = [
        "${pkgs.jdt-language-server}/bin/jdt-language-server"
        "-data"
        "/dev/null"
        "-configuration"
        "/dev/null"
      ];

      rootDir.__raw = "require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})";

      settings = {
        java = { };
      };

      initOptions = {
        bundles = { };
      };
    };
  };

  dataAndConfiguration = {
    plugins.nvim-jdtls = {
      enable = true;

      data = "/path/to/my/project";
      configuration = "/path/to/configuration";
    };
  };
}
