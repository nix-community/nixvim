{
  lib,
  helpers,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin {
  name = "cmake-tools";
  originalName = "cmake-tools.nvim";
  package = "cmake-tools-nvim";

  maintainers = [ helpers.maintainers.NathanFelber ];

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
      helpers.defaultNullOpts.mkAttrsOf lib.types.anything { "-DCMAKE_EXPORT_COMPILE_COMMANDS" = 1; }
        ''
          This will be passed when invoke `CMakeGenerate`.
        '';

    cmake_build_options = helpers.defaultNullOpts.mkAttrsOf lib.types.anything { } ''
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

    cmake_variants_message = {
      short = helpers.defaultNullOpts.mkAttrsOf lib.types.anything { show = true; } ''
        Whether to show short message.
      '';

      long =
        helpers.defaultNullOpts.mkAttrsOf lib.types.anything
          {
            show = true;
            max_length = 40;
          }
          ''
            Whether to show long message.
          '';
    };

    cmake_dap_configuration = {
      name = helpers.defaultNullOpts.mkStr "cpp" ''
        Name of the launch configuration.
      '';

      type = helpers.defaultNullOpts.mkStr "codelldb" ''
        Debug adapter to use.
      '';

      request = helpers.defaultNullOpts.mkStr "launch" ''
        Session initiation method.
      '';
    };

    cmake_executor = {
      name = helpers.defaultNullOpts.mkStr "quickfix" ''
        Name of the executor.
      '';

      opts = helpers.defaultNullOpts.mkAttrsOf lib.types.anything { } ''
        The options the executor will get, possible values depend on the executor type.
      '';
    };

    cmake_runner = {
      name = helpers.defaultNullOpts.mkStr "terminal" ''
        Name of the runner.
      '';

      opts = helpers.defaultNullOpts.mkAttrsOf lib.types.anything { } ''
        The options the runner will get, possible values depend on the runner type.
      '';
    };

    cmake_notifications = {
      runner.enabled = helpers.defaultNullOpts.mkBool true "";

      executor.enabled = helpers.defaultNullOpts.mkBool true "";

      spinner =
        helpers.defaultNullOpts.mkListOf lib.types.str
          [
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
          ]
          ''
            Icons used for progress display.
          '';

      refresh_rate_ms = helpers.defaultNullOpts.mkPositiveInt 100 ''
        How often to iterate icons.
      '';
    };
  };

  settingsExample = {
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
}
