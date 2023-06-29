{
  empty = {
    plugins.dap.extensions.dap-python.enable = true;
  };

  example = {
    plugins.dap.extensions.dap-python = {
      enable = true;

      customConfigurations = [
        {
          type = "python";
          request = "launch";
          name = "My custom launch configuration";
          program = "$\{file}";
          # ... more options; see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
        }
      ];
      resolvePython = ''
        function()
          return "/absolute/path/to/python"
        end
      '';
      testRunner = "customTestRunner";
      testRunners = {
        customTestRunner = ''
          function(classname, methodname, opts)
            local args = {classname, methodname}
            return 'modulename', args
          end
        '';
      };
    };
  };

  default = {
    plugins.dap.extensions.dap-python = {
      enable = true;

      console = "integratedTerminal";
      includeConfigs = true;
      adapterPythonPath = "python3";
    };
  };
}
