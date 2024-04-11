{
  empty = {
    plugins.cmake-tools.enable = true;
  };

  example = {
    plugins.cmake-tools = {
      enable = true;

      settings = {
        cmake_command = "cmake";
        ctest_command = "ctest";
        cmake_regenerate_on_save = true;
        cmake_generate_options = {"-DCMAKE_EXPORT_COMPILE_COMMANDS" = 1;};
        cmake_build_options = {};
        cmake_build_directory = "out/\${variant:buildType}";
        cmake_soft_link_compile_commands = true;
        cmake_compile_commands_from_lsp = false;
        cmake_kits_path = null;

        cmake_variants_message = {
          short = {show = true;};
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
          opts = {};
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
                strategy.__raw = ''
                  {
                    "terminal",
                  },
                '';
              };
              on_new_task = {
                __raw = ''
                  function(task) end
                '';
              };
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
          opts = {};
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
                strategy.__raw = ''
                  {
                    "terminal",
                  },
                '';
              };
              on_new_task = {
                __raw = ''
                  function(task) end
                '';
              };
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
          spinner = ["⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏"];
          refresh_rate_ms = 100;
        };
      };
    };
  };
}
