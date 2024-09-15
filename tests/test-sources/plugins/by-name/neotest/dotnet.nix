{ lib, pkgs, ... }:
{
  # TODO: added 2024-09-15
  # TODO: Re-enable when upstream builds in darwin sandbox
  example = lib.mkIf pkgs.stdenv.isLinux {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.dotnet = {
          enable = true;

          settings = {
            dap = {
              args = {
                justMyCode = false;
              };
              adapter_name = "netcoredbg";
            };
            custom_attributes = {
              xunit = [ "MyCustomFactAttribute" ];
              nunit = [ "MyCustomTestAttribute" ];
              mstest = [ "MyCustomTestMethodAttribute" ];
            };
            dotnet_additional_args = [ "--verbosity detailed" ];
            discovery_root = "project";
          };
        };
      };
    };
  };
}
