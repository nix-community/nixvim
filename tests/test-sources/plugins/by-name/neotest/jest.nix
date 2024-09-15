{ lib, pkgs, ... }:
{
  # TODO: added 2024-09-15
  # TODO: Re-enable when upstream builds in darwin sandbox
  example = lib.mkIf pkgs.stdenv.isLinux {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.jest = {
          enable = true;

          settings = {
            jestCommand = "npm test --";
            jestConfigFile = "custom.jest.config.ts";
            env = {
              CI = true;
            };
            cwd.__raw = ''
              function(path)
                return vim.fn.getcwd()
              end
            '';
          };
        };
      };
    };
  };
}
