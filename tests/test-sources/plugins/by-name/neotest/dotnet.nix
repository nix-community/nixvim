{
  example = {
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
