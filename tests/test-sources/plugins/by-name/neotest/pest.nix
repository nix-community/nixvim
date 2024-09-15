{ lib, pkgs, ... }:
{
  # TODO: added 2024-09-15
  # TODO: Re-enable when upstream builds in darwin sandbox
  example = lib.mkIf pkgs.stdenv.isLinux {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.pest = {
          enable = true;

          settings = {
            ignore_dirs = [
              "vendor"
              "node_modules"
            ];
            root_ignore_files = [ "phpunit-only.tests" ];
            test_file_suffixes = [
              "Test.php"
              "_test.php"
              "PestTest.php"
            ];
            sail_enabled.__raw = "function() return false end";
            sail_executable = "vendor/bin/sail";
            pest_cmd = "vendor/bin/pest";
            parallel = 16;
            compact = false;
            results_path.__raw = "function() return '/some/accessible/path' end";
          };
        };
      };
    };
  };
}
