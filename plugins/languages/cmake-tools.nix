{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "cmake-tools";
  originalName = "cmake-tools.nvim";
  defaultPackage = pkgs.vimPlugins.cmake-tools-nvim;

  maintainers = [helpers.maintainers.NathanFelber];

  extraPlugins = with pkgs.vimPlugins; [
    plenary-nvim
  ];

  settingsOptions = {
    cmake_command = helpers.defaultNullOpts.mkStr "cmake" ''
      This is used to specify cmake command path.
    '';

    ctest_command = helpers.defaultNullOpts.mkStr "ctest" ''
      This is used to specify ctest command path.
    '';

    cmake_regenerate_on_save = helpers.defaultNullOpts.mkBool true ''
      Auto generate when save CMakeLists.txt.
    '';

    cmake_generate_options =
      helpers.defaultNullOpts.mkAttributeSet ''
        { "-DCMAKE_EXPORT_COMPILE_COMMANDS" = 1; }
      ''
      ''
        This will be passed when invoke `CMakeGenerate`.
      '';

    cmake_build_options = helpers.defaultNullOpts.mkAttributeSet "{}" ''
      This will be passed when invoke `CMakeBuild`.
    '';

    cmake_build_directory = helpers.defaultNullOpts.mkStr "out/\${variant:buildType}" ''
      This is used to specify generate directory for cmake, allows macro expansion, relative to vim.loop.cwd().
    '';

    cmake_soft_link_compile_commands = helpers.defaultNullOpts.mkBool true ''
      This will automatically make a soft link from compile commands file to project root dir.
    '';

    cmake_compile_commands_from_lsp = helpers.defaultNullOpts.mkBool false ''
      This will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false.
    '';

    cmake_kits_path = helpers.defaultNullOpts.mkStr null ''
      This is used to specify global cmake kits path, see CMakeKits for detailed usage.
    '';

    cmake_variants_message =
      helpers.mkCompositeOption ''
        Settings for cmake variants messages.
      ''
      {
        short =
          helpers.defaultNullOpts.mkAttributeSet ''
            { show = true; }
          ''
          ''
            Whether to show short message.
          '';

        long =
          helpers.defaultNullOpts.mkAttributeSet ''
            { show = true; max_length = 40; }
          ''
          ''
            Whether to show long message.
          '';
      };

    cmake_dap_configuration =
      helpers.defaultNullOpts.mkAttributeSet ''
        {
          name = "cpp";
          type = "codelldb";
          request = "launch";
          stopOnEntry = false;
          runInTerminal = true;
          console = "integratedTerminal";
        }
      ''
      ''
        Dap configuration for cmake.
      '';

    cmake_executor =
      helpers.mkCompositeOption ''
        Executor to use.
      ''
      {
        name = helpers.defaultNullOpts.mkStr "quickfix" ''
          Name of the executor.
        '';

        opts = helpers.defaultNullOpts.mkAttributeSet "{}" ''
          The options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
        '';

        default_opts =
          helpers.defaultNullOpts.mkAttributeSet ''
            {
              quickfix = {
                show = "always"; # "always", "only_on_error"
                position = "belowright"; # "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them
                size = 10;
                encoding = "utf-8"; # if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
                auto_close_when_success = true; # typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
              };

              toggleterm = {
                direction = "float"; # 'vertical' | 'horizontal' | 'tab' | 'float'
                close_on_exit = false; # whether close the terminal when exit
                auto_scroll = true; # whether auto scroll to the bottom
              };

              overseer = {
                new_task_opts = {
                  strategy.__raw = '''
                    {
                      "terminal",
                    },
                  '''';
                }; # options to pass into the `overseer.new_task` command
                on_new_task = {
                  __raw = '''
                    function(task) end
                  ''';
                }; # a function that gets overseer.Task when it is created, before calling `task:start`
              };

              terminal = {
                name = "Main Terminal";
                prefix_name = "[CMakeTools]: "; # This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
                split_direction = "horizontal"; # "horizontal", "vertical"
                split_size = 11;

                # Window handling
                single_terminal_per_instance = true; # Single viewport, multiple windows
                single_terminal_per_tab = true; # Single viewport per tab
                keep_terminal_static_location = true; # Static location of the viewport if available

                # Running Tasks
                start_insert = false; # If you want to enter terminal with :startinsert upon using :CMakeRun
                focus = false; # Focus on terminal when cmake task is launched.
              }; # terminal executor uses the values in cmake_terminal
            }
          ''
          ''
            A list of default and possible values for executors.
          '';
      };

    cmake_runner =
      helpers.mkCompositeOption ''
        Runner to use.
      ''
      {
        name = helpers.defaultNullOpts.mkStr "terminal" ''
          Name of the runner.
        '';

        opts = helpers.defaultNullOpts.mkAttributeSet "{}" ''
          The options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
        '';

        default_opts =
          helpers.defaultNullOpts.mkAttributeSet ''
            {
              quickfix = {
                show = "always"; # "always", "only_on_error"
                position = "belowright"; # "bottom", "top"
                size = 10;
                encoding = "utf-8";
                auto_close_when_success = true; # typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
              };

              toggleterm = {
                direction = "float"; # 'vertical' | 'horizontal' | 'tab' | 'float'
                close_on_exit = false; # whether close the terminal when exit
                auto_scroll = true; # whether auto scroll to the bottom
              };

              overseer = {
                new_task_opts = {
                  strategy.__raw = '''
                    {
                      "terminal",
                    },
                  '''';
                }; # options to pass into the `overseer.new_task` command
                on_new_task = {
                  __raw = '''
                    function(task) end
                  ''';
                }; # a function that gets overseer.Task when it is created, before calling `task:start`
              };

              terminal = {
                name = "Main Terminal";
                prefix_name = "[CMakeTools]: "; # This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
                split_direction = "horizontal"; # "horizontal", "vertical"
                split_size = 11;

                # Window handling
                single_terminal_per_instance = true; # Single viewport, multiple windows
                single_terminal_per_tab = true; # Single viewport per tab
                keep_terminal_static_location = true; # Static location of the viewport if available

                # Running Tasks
                start_insert = false; # If you want to enter terminal with :startinsert upon using :CMakeRun
                focus = false; # Focus on terminal when cmake task is launched.
              };
            }
          ''
          ''
            A list of default and possible values for runner.
          '';
      };

    cmake_notifications =
      helpers.mkCompositeOption ''
        Notification settings.
      ''
      {
        runner = helpers.mkCompositeOption "" {
          enabled = helpers.defaultNullOpts.mkBool true "";
        };

        executor = helpers.mkCompositeOption "" {
          enabled = helpers.defaultNullOpts.mkBool true "";
        };

        spinner = helpers.defaultNullOpts.mkListOf lib.types.str ''[ "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏" ]'' ''
          Icons used for progress display.
        '';

        refresh_rate_ms = helpers.defaultNullOpts.mkPositiveInt 100 ''
          How often to iterate icons.
        '';
      };
  };

  settingsExample = {
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
          show = "always"; # "always", "only_on_error"
          position = "belowright"; # "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them
          size = 10;
          encoding = "utf-8"; # if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
          auto_close_when_success = true; # typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
        };

        toggleterm = {
          direction = "float"; # 'vertical' | 'horizontal' | 'tab' | 'float'
          close_on_exit = false; # whether close the terminal when exit
          auto_scroll = true; # whether auto scroll to the bottom
        };

        overseer = {
          new_task_opts = {
            strategy.__raw = ''
              {
                "terminal",
              },
            '';
          }; # options to pass into the `overseer.new_task` command
          on_new_task = {
            __raw = ''
              function(task) end
            '';
          }; # a function that gets overseer.Task when it is created, before calling `task:start`
        };

        terminal = {
          name = "Main Terminal";
          prefix_name = "[CMakeTools]: "; # This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
          split_direction = "horizontal"; # "horizontal", "vertical"
          split_size = 11;

          # Window handling
          single_terminal_per_instance = true; # Single viewport, multiple windows
          single_terminal_per_tab = true; # Single viewport per tab
          keep_terminal_static_location = true; # Static location of the viewport if available

          # Running Tasks
          start_insert = false; # If you want to enter terminal with :startinsert upon using :CMakeRun
          focus = false; # Focus on terminal when cmake task is launched.
        }; # terminal executor uses the values in cmake_terminal
      };
    };

    cmake_runner = {
      name = "terminal";
      opts = {};
      default_opts = {
        quickfix = {
          show = "always"; # "always", "only_on_error"
          position = "belowright"; # "bottom", "top"
          size = 10;
          encoding = "utf-8";
          auto_close_when_success = true; # typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
        };

        toggleterm = {
          direction = "float"; # 'vertical' | 'horizontal' | 'tab' | 'float'
          close_on_exit = false; # whether close the terminal when exit
          auto_scroll = true; # whether auto scroll to the bottom
        };

        overseer = {
          new_task_opts = {
            strategy.__raw = ''
              {
                "terminal",
              },
            '';
          }; # options to pass into the `overseer.new_task` command
          on_new_task = {
            __raw = ''
              function(task) end
            '';
          }; # a function that gets overseer.Task when it is created, before calling `task:start`
        };

        terminal = {
          name = "Main Terminal";
          prefix_name = "[CMakeTools]: "; # This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
          split_direction = "horizontal"; # "horizontal", "vertical"
          split_size = 11;

          # Window handling
          single_terminal_per_instance = true; # Single viewport, multiple windows
          single_terminal_per_tab = true; # Single viewport per tab
          keep_terminal_static_location = true; # Static location of the viewport if available

          # Running Tasks
          start_insert = false; # If you want to enter terminal with :startinsert upon using :CMakeRun
          focus = false; # Focus on terminal when cmake task is launched.
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
}
