{ lib, pkgs, ... }:
{
  # TODO: added 2024-09-15
  # TODO: Re-enable when upstream builds in darwin sandbox
  example = lib.mkIf pkgs.stdenv.isLinux {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.minitest = {
          enable = true;

          settings = {
            test_cmd.__raw = ''
              function()
                return vim.tbl_flatten({
                  "bundle",
                  "exec",
                  "rails",
                  "test",
                })
              end
            '';
          };
        };
      };
    };
  };
}
