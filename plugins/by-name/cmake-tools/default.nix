{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "cmake-tools";
  originalName = "cmake-tools.nvim";
  package = "cmake-tools-nvim";

  maintainers = [ lib.maintainers.NathanFelber ];

  settingsOptions = {
    cmake_command = defaultNullOpts.mkStr "cmake" ''
      This is used to specify cmake command path.
    '';

    ctest_command = defaultNullOpts.mkStr "ctest" ''
      This is used to specify ctest command path.
    '';

    cmake_regenerate_on_save = defaultNullOpts.mkBool true ''
      Auto generate when save CMakeLists.txt.
    '';

    cmake_generate_options =
      defaultNullOpts.mkAttrsOf lib.types.anything { "-DCMAKE_EXPORT_COMPILE_COMMANDS" = 1; }
        ''
          This will be passed when invoke `CMakeGenerate`.
        '';

    cmake_build_options = defaultNullOpts.mkAttrsOf lib.types.anything { } ''
      This will be passed when invoke `CMakeBuild`.
    '';

    cmake_build_directory = defaultNullOpts.mkStr "out/\${variant:buildType}" ''
      This is used to specify generate directory for cmake, allows macro expansion, relative to vim.loop.cwd().
    '';

    cmake_soft_link_compile_commands = defaultNullOpts.mkBool true ''
      This will automatically make a soft link from compile commands file to project root dir.
    '';

    cmake_compile_commands_from_lsp = defaultNullOpts.mkBool false ''
      This will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false.
    '';

    cmake_kits_path = defaultNullOpts.mkStr null ''
      This is used to specify global cmake kits path, see CMakeKits for detailed usage.
    '';

    cmake_variants_message = {
      short = defaultNullOpts.mkAttrsOf lib.types.anything { show = true; } ''
        Whether to show short message.
      '';

      long =
        defaultNullOpts.mkAttrsOf lib.types.anything
          {
            show = true;
            max_length = 40;
          }
          ''
            Whether to show long message.
          '';
    };

    cmake_dap_configuration = {
      name = defaultNullOpts.mkStr "cpp" ''
        Name of the launch configuration.
      '';

      type = defaultNullOpts.mkStr "codelldb" ''
        Debug adapter to use.
      '';

      request = defaultNullOpts.mkStr "launch" ''
        Session initiation method.
      '';
    };

    cmake_executor = {
      name = defaultNullOpts.mkStr "quickfix" ''
        Name of the executor.
      '';

      opts = defaultNullOpts.mkAttrsOf lib.types.anything { } ''
        The options the executor will get, possible values depend on the executor type.
      '';
    };

    cmake_runner = {
      name = defaultNullOpts.mkStr "terminal" ''
        Name of the runner.
      '';

      opts = defaultNullOpts.mkAttrsOf lib.types.anything { } ''
        The options the runner will get, possible values depend on the runner type.
      '';
    };

    cmake_notifications = {
      runner.enabled = defaultNullOpts.mkBool true "";

      executor.enabled = defaultNullOpts.mkBool true "";

      spinner =
        defaultNullOpts.mkListOf lib.types.str
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

      refresh_rate_ms = defaultNullOpts.mkPositiveInt 100 ''
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
