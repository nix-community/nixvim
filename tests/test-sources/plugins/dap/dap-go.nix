{
  empty = {
    plugins.dap.extensions.dap-go.enable = true;
  };

  default = {
    plugins.dap.extensions.dap-go = {
      enable = true;

      dapConfigurations = [
        {
          # Must be "go" or it will be ignored by the plugin
          type = "go";
          name = "Attach remote";
          mode = "remote";
          request = "attach";
        }
      ];
      delve = {
        path = "dlv";
        initializeTimeoutSec = 20;
        port = "$\{port}";
        args = [];
      };
    };
  };
}
