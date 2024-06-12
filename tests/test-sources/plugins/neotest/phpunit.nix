{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.phpunit = {
          enable = true;

          settings = {
            phpunit_cmd.__raw = ''
              function()
                return "vendor/bin/phpunit"
              end
            '';
            root_files = [
              "composer.json"
              "phpunit.xml"
              ".gitignore"
            ];
            filter_dirs = [
              ".git"
              "node_modules"
            ];
            env = {
              XDEBUG_CONFIG = "idekey=neotest";
            };
            dap = null;
          };
        };
      };
    };
  };
}
