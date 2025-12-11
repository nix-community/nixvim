{
  empty = {
    plugins.dap.enable = true;
  };

  example = {
    plugins.dap = {
      enable = true;

      adapters = {
        python.__raw = ''
          function(cb, config)
            if config.request == 'attach' then
              local port = (config.connect or config).port
              local host = (config.connect or config).host or '127.0.0.1'
              cb({
                type = 'server',
                port = assert(port, '`connect.port` is required for a python `attach` configuration'),
                host = host,
                options = {
                  source_filetype = 'python',
                },
              })
            else
              cb({
                type = 'executable',
                command = 'path/to/virtualenvs/debugpy/bin/python',
                args = { '-m', 'debugpy.adapter' },
                options = {
                  source_filetype = 'python',
                },
              })
            end
          end
        '';

        executables = {
          pythonStructured = {
            command = ".virtualenvs/tools/bin/python";
            args = [
              "-m"
              "debugpy.adapter"
            ];
          };
          lldb.__raw = ''
            function(on_config, config)
              local command = config.lldbCommand or "lldb-vscode"
              on_config({
                type = "executable",
                command = command,
                name = "lldb",
              })
            end
          '';
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
