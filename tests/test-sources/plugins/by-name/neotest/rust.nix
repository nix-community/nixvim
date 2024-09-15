{ lib, pkgs, ... }:
{
  # TODO: added 2024-09-15
  # TODO: Re-enable when upstream builds in darwin sandbox
  example = lib.mkIf pkgs.stdenv.isLinux {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.rust = {
          enable = true;

          settings = {
            args = [ "--no-capture" ];
            dap_adapter = "lldb";
          };
        };
      };
    };
  };
}
