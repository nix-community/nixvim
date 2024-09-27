{
  lib,
  helpers,
  pkgs,
}:
with lib;
{
  tools =
    let
      executors = [
        "termopen"
        "quickfix"
        "toggleterm"
        "vimux"
        "neotest"
      ];
      testExecutors = executors ++ [ "background" ];
      executorSubmodule = types.submodule {
        options = {
          execute_command = helpers.mkNullOrLuaFn ''
            ```lua
              fun(cmd:string,args:string[],cwd:string|nil,opts?:RustaceanExecutorOpts)

              Example:
              ```lua
                function(command, args, cwd, _)
                  require('toggleterm.terminal').Terminal
                    :new({
                      dir = cwd,
                      cmd = require('rustaceanvim.shell').make_command_from_args(command, args),
                      close_on_exit = false,
                      direction = 'vertical',
                    })
                    :toggle()
                end
              ```
            ```
          '';
        };
      };
    in
    {
      executor =
        helpers.defaultNullOpts.mkNullable (with types; either (enum executors) executorSubmodule)
          "termopen"
          ''
            The executor to use for runnables/debuggables.
            Either an executor alias or an attrs with the `execute_command` key.
          '';

      test_executor =
        helpers.mkNullOrOption (with types; either (enum testExecutors) executorSubmodule)
          ''
            The executor to use for runnables that are tests/testables
            Either a test executor alias or an attrs with the `execute_command` key.
          '';

      crate_test_executor =
        helpers.mkNullOrOption (with types; either (enum testExecutors) executorSubmodule)
          ''
            The executor to use for runnables that are crate test suites (`--all-targets`).
            Either a test executor alias or an attrs with the `execute_command` key.
          '';

      cargo_override = helpers.mkNullOrStr ''
        Set this to override the 'cargo' command for runnables, debuggables (etc., e.g. to `"cross"`).
        If set, this takes precedence over `enable_nextest`.
      '';

      enable_nextest = helpers.defaultNullOpts.mkBool true ''
        Whether to enable nextest.
        If enabled, `cargo test` commands will be transformed to `cargo nextest run` commands.
        Defaults to `true` if cargo-nextest is detected.
        Ignored if `cargo_override` is set.
      '';

      enable_clippy = helpers.defaultNullOpts.mkBool true ''
        Whether to enable clippy checks on save if a clippy installation is detected.
      '';

      on_initialized = helpers.mkNullOrLuaFn ''
        `fun(health:RustAnalyzerInitializedStatus)`
        Function that is invoked when the LSP server has finished initializing.
      '';

      reload_workspace_from_cargo_toml = helpers.defaultNullOpts.mkBool true ''
        Automatically call `RustReloadWorkspace` when writing to a `Cargo.toml` file.
      '';

      hover_actions = {
        replace_builtin_hover = helpers.defaultNullOpts.mkBool true ''
          Whether to replace Neovim's built-in `vim.lsp.buf.hover` with hover actions.
        '';
      };

      code_actions = {
        group_icon = helpers.defaultNullOpts.mkStr " ▶" ''
          Text appended to a group action.
        '';

        ui_select_fallback = helpers.defaultNullOpts.mkBool false ''
          Whether to fall back to `vim.ui.select` if there are no grouped code actions.
        '';
      };

      float_win_config = {
        auto_focus = helpers.defaultNullOpts.mkBool false ''
          Whether the window gets automatically focused.
        '';

        open_split =
          helpers.defaultNullOpts.mkEnumFirstDefault
            [
              "horizontal"
              "vertical"
            ]
            ''
              Whether splits opened from floating preview are vertical.
            '';
      };

      crate_graph = {
        backend = helpers.defaultNullOpts.mkStr "x11" ''
          Backend used for displaying the graph.
          See: https://graphviz.org/docs/outputs
        '';

        output = helpers.mkNullOrStr ''
          Where to store the output.
          No output if unset.
          Relative path from `cwd`.
        '';

        full = helpers.defaultNullOpts.mkBool true ''
          `true` for all crates.io and external crates, false only the local crates.
        '';

        enabled_graphviz_backends =
          helpers.defaultNullOpts.mkListOf types.str
            [
              "bmp"
              "cgimage"
              "canon"
              "dot"
              "gv"
              "xdot"
              "xdot1.2"
              "xdot1.4"
              "eps"
              "exr"
              "fig"
              "gd"
              "gd2"
              "gif"
              "gtk"
              "ico"
              "cmap"
              "ismap"
              "imap"
              "cmapx"
              "imap_np"
              "cmapx_np"
              "jpg"
              "jpeg"
              "jpe"
              "jp2"
              "json"
              "json0"
              "dot_json"
              "xdot_json"
              "pdf"
              "pic"
              "pct"
              "pict"
              "plain"
              "plain-ext"
              "png"
              "pov"
              "ps"
              "ps2"
              "psd"
              "sgi"
              "svg"
              "svgz"
              "tga"
              "tiff"
              "tif"
              "tk"
              "vml"
              "vmlz"
              "wbmp"
              "webp"
              "xlib"
              "x11"
            ]
            ''
              Override the enabled graphviz backends list, used for input validation and autocompletion.
            '';

        pipe = helpers.mkNullOrStr ''
          Override the pipe symbol in the shell command.
          Useful if using a shell that is not supported by this plugin.
        '';
      };

      open_url = helpers.defaultNullOpts.mkLuaFn "require('rustaceanvim.os').open_url" ''
        If set, overrides how to open URLs.
        `fun(url:string):nil`
      '';
    };

  server = {
    auto_attach = helpers.mkNullOrStrLuaFnOr types.bool ''
      Whether to automatically attach the LSP client.
      Defaults to `true` if the `rust-analyzer` executable is found.

      This can also be the definition of a function (`fun():boolean`).

      Plugin default:
      ```lua
        function(bufnr)
          if #vim.bo[bufnr].buftype > 0 then
            return false
          end
          local path = vim.api.nvim_buf_get_name(bufnr)
          if not os.is_valid_file_path(path) then
            return false
          end
          local cmd = types.evaluate(RustaceanConfig.server.cmd)
          ---@cast cmd string[]
          local rs_bin = cmd[1]
          return vim.fn.executable(rs_bin) == 1
        end
      ```
    '';

    on_attach = helpers.mkNullOrLuaFn ''
      Function to call on attach.
      If `plugins.lsp` is enabled, it defaults to the Nixvim global `__lspOnAttach` function.
      Otherwise it defaults to `null`.
    '';

    cmd = helpers.mkNullOrStrLuaFnOr (with types; listOf str) ''
      Command and arguments for starting rust-analyzer.

      This can also be the definition of a function:
      `fun(project_root:string|nil,default_settings:table):table`

      Plugin default:
      ```lua
        function()
          return { 'rust-analyzer', '--log-file', RustaceanConfig.server.logfile }
        end
      ```
    '';

    default_settings =
      helpers.mkNullOrStrLuaFnOr
        (types.submodule {
          options.rust-analyzer = import ../../lsp/language-servers/rust-analyzer-config.nix lib helpers;
          freeformType = with types; attrsOf anything;
        })
        ''
          Setting passed to rust-analyzer.
          Defaults to a function that looks for a `rust-analyzer.json` file or returns an empty table.
          See https://rust-analyzer.github.io/manual.html#configuration.

          This can also be the definition of a function:
          `fun(project_root:string|nil, default_settings: table|nil):table`

          Plugin default:
          ```lua
            function(project_root, default_settings)
              return require('rustaceanvim.config.server').load_rust_analyzer_settings(project_root, { default_settings = default_settings })
            end
          ```
        '';

    standalone = helpers.defaultNullOpts.mkBool true ''
      Standalone file support (enabled by default).
      Disabling it may improve rust-analyzer's startup time.
    '';

    logfile = helpers.defaultNullOpts.mkStr { __raw = "vim.fn.tempname() .. '-rust-analyzer.log'"; } ''
      The path to the rust-analyzer log file.
    '';

    load_vscode_settings = helpers.defaultNullOpts.mkBool false ''
      Whether to search (upward from the buffer) for rust-analyzer settings in `.vscode/settings` json.
      If found, loaded settings will override configured options.
    '';
  };

  dap = {
    autoload_configurations = helpers.defaultNullOpts.mkBool true ''
      Whether to autoload nvim-dap configurations when rust-analyzer has attached.
    '';

    adapter =
      let
        dapConfig = types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            # Common options
            type = mkOption {
              type = types.enum [
                "executable"
                "server"
              ];
              description = "The type for the debug adapter.";
            };

            name = helpers.mkNullOrStr "The name of this adapter.";

            # Executable
            command = helpers.defaultNullOpts.mkStr "lldb-vscode" ''
              The command to run for this adapter.
            '';

            args = helpers.mkNullOrStr "Its arguments.";

            # Server
            host = helpers.mkNullOrStr "The host to connect to.";

            port = helpers.mkNullOrStr "The port to connect to.";

            executable = {
              command = helpers.mkNullOrStr "The command for the executable.";

              args = helpers.mkNullOrOption (with lib.types; maybeRaw (listOf str)) ''
                Its arguments.
              '';
            };
          };
        };
      in
      helpers.mkNullOrStrLuaFnOr (with types; either (enum [ false ]) dapConfig) ''
        Defaults to creating the `rt_lldb` adapter, which is a `DapServerConfig` if `codelldb`
        is detected, and a `DapExecutableConfig` if `lldb` is detected.
        Set to `false` to disable.
      '';
  };
}
