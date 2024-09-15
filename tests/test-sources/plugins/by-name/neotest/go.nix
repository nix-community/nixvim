{ lib, pkgs, ... }:
{
  # TODO: added 2024-09-15
  # TODO: Re-enable when upstream builds in darwin sandbox
  example = lib.mkIf pkgs.stdenv.isLinux {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.go = {
          enable = true;

          settings = {
            experimental = {
              test_table = true;
            };
            args = [
              "-count=1"
              "-timeout=60s"
            ];
          };
        };
      };
    };
  };
}
