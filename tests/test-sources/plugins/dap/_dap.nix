{
  empty = {
    plugins.dap.enable = true;
  };

  example = {
    plugins.dap = {
      enable = true;

      adapters = {
        executables = {
          python = {
            command = ".virtualenvs/tools/bin/python";
            args = [
              "-m"
              "debugpy.adapter"
            ];
          };
        };
        servers = {
          java = ''
            function(callback, config)
              M.execute_command({command = 'vscode.java.startDebugSession'}, function(err0, port)
                assert(not err0, vim.inspect(err0))
                callback({ type = 'server'; host = '127.0.0.1'; port = port; })
              end)
            end
          '';
          javaEnriched = {
            host = "127.0.0.1";
            port = 8080;
            enrichConfig = ''
              function(config, on_config)
                local final_config = vim.deepcopy(config)
                final_config.extra_property = 'This got injected by the adapter'
                on_config(final_config)
              end
            '';
          };
        };
      };
      configurations = {
        python = [
          {
            type = "python";
            request = "launch";
            name = "Launch file";
            program = "$\{file}";
          }
        ];
      };
    };
  };

  default = {
    plugins.dap = {
      enable = true;

      adapters = {
        executables = { };
        servers = { };
      };
      configurations = { };
      signs = {
        dapStopped = {
          text = "→";
          texthl = "DiagnosticWarn";
        };
        dapBreakpoint = {
          text = "B";
          texthl = "DiagnosticInfo";
        };
        dapBreakpointRejected = {
          text = "R";
          texthl = "DiagnosticError";
        };
        dapBreakpointCondition = {
          text = "C";
          texthl = "DiagnosticInfo";
        };
        dapLogPoint = {
          text = "L";
          texthl = "DiagnosticInfo";
        };
      };
    };
  };
}
