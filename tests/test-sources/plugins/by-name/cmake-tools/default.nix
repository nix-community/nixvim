{
  empty = {
    plugins.cmake-tools.enable = true;
  };

  default = {
    plugins.cmake-tools = {
      enable = true;

      settings = {
        cmake_command = "cmake";
        ctest_command = "ctest";
        cmake_regenerate_on_save = true;
        cmake_generate_options = {
          "-DCMAKE_EXPORT_COMPILE_COMMANDS" = 1;
        };
        cmake_build_options.__empty = { };
        cmake_build_directory = "out/\${variant:buildType}";
        cmake_soft_link_compile_commands = true;
        cmake_compile_commands_from_lsp = false;
        cmake_kits_path.__raw = "nil";

        cmake_variants_message = {
          short = {
            show = true;
          };
          long = {
            show = true;
            max_length = 40;
          };
        };

        cmake_dap_configuration = {
          name = "cpp";
          type = "codelldb";
          request = "launch";
          stopOnEntry = false;
          runInTerminal = true;
          console = "integratedTerminal";
        };

        cmake_executor = {
          name = "quickfix";
          opts.__empty = { };
          default_opts = {
            quickfix = {
              show = "always";
              position = "belowright";
              size = 10;
              encoding = "utf-8";
              auto_close_when_success = true;
            };

            toggleterm = {
              direction = "float";
              close_on_exit = false;
              auto_scroll = true;
            };

            overseer = {
              new_task_opts = {
                strategy.__unkeyed-1 = "terminal";
              };
              on_new_task.__raw = ''
                function(task) end
              '';
            };

            terminal = {
              name = "Main Terminal";
              prefix_name = "[CMakeTools]: ";
              split_direction = "horizontal";
              split_size = 11;

              single_terminal_per_instance = true;
              single_terminal_per_tab = true;
              keep_terminal_static_location = true;

              start_insert = false;
              focus = false;
            };
          };
        };

        cmake_runner = {
          name = "terminal";
          opts.__empty = { };
          default_opts = {
            quickfix = {
              show = "always";
              position = "belowright";
              size = 10;
              encoding = "utf-8";
              auto_close_when_success = true;
            };

            toggleterm = {
              direction = "float";
              close_on_exit = false;
              auto_scroll = true;
            };

            overseer = {
              new_task_opts = {
                strategy.__unkeyed-1 = "terminal";
              };
              on_new_task.__raw = ''
                function(task) end
              '';
            };

            terminal = {
              name = "Main Terminal";
              prefix_name = "[CMakeTools]: ";
              split_direction = "horizontal";
              split_size = 11;
              single_terminal_per_instance = true;
              single_terminal_per_tab = true;
              keep_terminal_static_location = true;
              start_insert = false;
              focus = false;
            };
          };
        };

        cmake_notifications = {
          runner.enabled = true;
          executor.enabled = true;
          spinner = [
            "⠋"
            "⠙"
            "⠹"
            "⠸"
            "⠼"
            "⠴"
            "⠦"
            "⠧"
            "⠇"
            "⠏"
          ];
          refresh_rate_ms = 100;
        };
      };
    };
  };

  example = {
    plugins.toggleterm.enable = true;

    plugins.cmake-tools = {
      enable = true;

      settings = {
        cmake_regenerate_on_save = false;
        cmake_build_directory = "build/\${variant:buildtype}";
        cmake_soft_link_compile_commands = false;

        cmake_dap_configuration = {
          name = "Launch file";
          type = "codelldb";
          request = "launch";
          program.__raw = ''
            function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end
          '';
          cwd = "\${workspaceFolder}";
          stopOnEntry = false;
        };

        cmake_executor.name = "toggleterm";
        cmake_runner.name = "toggleterm";

        cmake_notifications = {
          spinner = [
            "▱▱▱▱▱▱▱"
            "▰▱▱▱▱▱▱"
            "▰▰▱▱▱▱▱"
            "▰▰▰▱▱▱▱"
            "▰▰▰▰▱▱▱"
            "▰▰▰▰▰▱▱"
            "▰▰▰▰▰▰▱"
            "▰▰▰▰▰▰▰"
          ];
          refresh_rate_ms = 80;
        };
      };
    };
  };
}
