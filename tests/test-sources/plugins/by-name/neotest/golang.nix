{ lib, pkgs, ... }:
{
  # TODO: added 2024-09-15
  # TODO: Re-enable when upstream builds in darwin sandbox
  example = lib.mkIf pkgs.stdenv.isLinux {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.golang = {
          enable = true;

          settings = {
            dap_go_enabled = true;
            testify_enabled = false;
            warn_test_name_dupes = true;
            warn_test_not_executed = true;
            args = [
              "-v"
              "-race"
              "-count=1"
            ];
          };
        };
      };
    };
  };
}
