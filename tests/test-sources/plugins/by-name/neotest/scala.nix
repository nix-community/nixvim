{ lib, pkgs, ... }:
{
  # TODO: added 2024-09-15
  # TODO: Re-enable when upstream builds in darwin sandbox
  example = lib.mkIf pkgs.stdenv.isLinux {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.scala = {
          enable = true;

          settings = {
            args = [ "--no-color" ];
            runner = "bloop";
            framework = "utest";
          };
        };
      };
    };
  };
}
