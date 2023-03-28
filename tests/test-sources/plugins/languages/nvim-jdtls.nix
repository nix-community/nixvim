{pkgs}: {
  empty = {
    plugins.nvim-jdtls.enable = true;
  };

  example = {
    plugins.nvim-jdtls = {
      enable = true;

      cmd = ["${pkgs.jdt-language-server}/bin/jdt-language-server"];

      rootDir.__raw = "require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})";

      settings = {
        java = {};
      };

      initOptions = {
        bundles = {};
      };
    };
  };
}
