{ lib, pkgs, ... }:
{
  # TODO: added 2024-09-15
  # TODO: Re-enable when upstream builds in darwin sandbox
  example = lib.mkIf pkgs.stdenv.isLinux {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.python = {
          enable = true;

          settings = {
            dap.justMyCode = false;
            args = [
              "--log-level"
              "DEBUG"
            ];
            runner = "pytest";
            python = ".venv/bin/python";
            is_test_file.__raw = ''
              function(file_path)
                return true
              end
            '';
            pytest_discover_instances = true;
          };
        };
      };
    };
  };
}
