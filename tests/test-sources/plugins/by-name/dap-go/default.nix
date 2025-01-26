{
  empty = {
    plugins.dap-go.enable = true;
  };

  default = {
    plugins.dap-go = {
      enable = true;

      settings = {
        dap_configurations = [
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
          initialize_timeout_sec = 20;
          port = "$\{port}";
          args = [ ];
          build_flags = "-tags=unit";
        };
      };
    };
  };
}
