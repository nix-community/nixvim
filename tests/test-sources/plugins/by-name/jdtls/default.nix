{ lib, pkgs }:
{
  example = {
    plugins.jdtls = {
      enable = true;
      jdtLanguageServerPackage = null;

      settings = {
        cmd = [
          "${pkgs.jdt-language-server}/bin/jdt-language-server"
          "-data"
          "/dev/null"
          "-configuration"
          "/dev/null"
        ];

        root_dir.__raw = "require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})";

        settings = {
          java.__empty = { };
        };

        init_options = {
          bundles.__empty = { };
        };
      };
    };
  };

  dataAndConfiguration = {
    plugins.jdtls = {
      enable = true;

      settings.cmd = [
        "jdtls"
        "-data"
        "/path/to/my/project"
        "-configuration"
        "/path/to/configuration"
      ];
    };
  };

  rawStringInCmd = {
    plugins.jdtls = {
      enable = true;

      settings = {
        cmd = [
          (lib.getExe pkgs.jdt-language-server)
          { __raw = "'--jvm-arg='..vim.api.nvim_eval('g:NVIM_LOMBOK')"; }
        ];
      };
    };
  };
}
