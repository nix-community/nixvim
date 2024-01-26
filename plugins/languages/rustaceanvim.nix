{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.rustaceanvim;
in {
  meta.maintainers = [maintainers.GaetanLepage];

  options.plugins.rustaceanvim =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "rustaceanvim";

      package = helpers.mkPackageOption "rustaceanvim" pkgs.vimPlugins.rustaceanvim;

      rustAnalyzerPackage = mkOption {
        type = with types; nullOr package;
        default = pkgs.rust-analyzer;
        description = ''
          Which package to use for `rust-analyzer`.
          Set to `null` to disable its automatic installation.
        '';
        example = null;
      };

      tools = {
        executor =
          helpers.defaultNullOpts.mkNullable
          (
            with helpers.nixvimTypes;
              either
              strLuaFn
              (enum ["termopen" "quickfix" "toggleterm" "vimux"])
          )
          "termopen"
          "How to execute terminal commands.";

        onInitialized = helpers.mkNullOrLuaFn ''
          `fun(health:RustAnalyzerInitializedStatus)`
          Function that is invoked when the LSP server has finished initializing.
        '';

        reloadWorkspaceFromCargoToml = helpers.defaultNullOpts.mkBool true ''
          Automatically call `RustReloadWorkspace` when writing to a `Cargo.toml` file.
        '';

        hoverActions = {
          replaceBuiltinHover = helpers.defaultNullOpts.mkBool true ''
            Whether to replace Neovim's built-in `vim.lsp.buf.hover` with hover actions.
          '';
        };

        floatWinConfig =
          helpers.defaultNullOpts.mkAttrsOf types.anything
          ''
            {
              border = [
                ["╭" "FloatBorder"]
                ["─" "FloatBorder"]
                ["╮" "FloatBorder"]
                ["│" "FloatBorder"]
                ["╯" "FloatBorder"]
                ["─" "FloatBorder"]
                ["╰" "FloatBorder"]
                ["│" "FloatBorder"]
              ];
              max_width = null;
              max_height = null;
              auto_focus = false;
            }
          ''
          "Options applied to floating windows. See |api-win_config|.";

        crateGraph = {
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

          enabledGraphvizBackends =
            helpers.defaultNullOpts.mkListOf types.str
            ''
              [
                "bmp" "cgimage" "canon" "dot" "gv" "xdot" "xdot1.2" "xdot1.4" "eps" "exr" "fig" "gd"
                "gd2" "gif" "gtk" "ico" "cmap" "ismap" "imap" "cmapx" "imap_np" "cmapx_np" "jpg"
                "jpeg" "jpe" "jp2" "json" "json0" "dot_json" "xdot_json" "pdf" "pic" "pct" "pict"
                "plain" "plain-ext" "png" "pov" "ps" "ps2" "psd" "sgi" "svg" "svgz" "tga" "tiff"
                "tif" "tk" "vml" "vmlz" "wbmp" "webp" "xlib" "x11"
              ]
            ''
            ''
              Override the enabled graphviz backends list, used for input validation and autocompletion.
            '';

          pipe = helpers.mkNullOrStr ''
            Overide the pipe symbol in the shell command.
            Useful if using a shell that is not supported by this plugin.
          '';
        };

        openUrl = helpers.defaultNullOpts.mkLuaFn "require('rustaceanvim.os').open_url" ''
          If set, overrides how to open URLs.
        '';
      };

      server = {
        autoAttach = helpers.mkNullOrStrLuaFnOr types.bool ''
          Whether to automatically attach the LSP client.
          Defaults to `true` if the `rust-analyzer` executable is found.

          This can also be the definition of a function (`fun():boolean`).

          Default:
          ```lua
            function()
              local cmd = types.evaluate(RustaceanConfig.server.cmd)
              ---@cast cmd string[]
              local rs_bin = cmd[1]
              return vim.fn.executable(rs_bin) == 1
            end
          ```
        '';

        onAttach = helpers.defaultNullOpts.mkLuaFn "__lspOnAttach" "Function to call on attach";

        cmd = helpers.mkNullOrStrLuaFnOr (with types; listOf str) ''
          Command and arguments for starting rust-analyzer.

          This can also be the definition of a function (`fun():string[]`).

          Default:
          ```lua
            function()
              return { 'rust-analyzer', '--log-file', RustaceanConfig.server.logfile }
            end
          ```
        '';

        settings =
          helpers.mkNullOrStrLuaFnOr (types.submodule {
            options =
              import ../lsp/language-servers/rust-analyzer-config.nix lib pkgs;
          })
          ''
            Setting passed to rust-analyzer.
            Defaults to a function that looks for a `rust-analyzer.json` file or returns an empty table.
            See https://rust-analyzer.github.io/manual.html#configuration.

            This can also be the definition of a function (`fun(project_root:string|nil):table`).

            Default:
            ```lua
              function(project_root)
                return require('rustaceanvim.config.server').load_rust_analyzer_settings(project_root)
              end
            ```
          '';

        standalone = helpers.defaultNullOpts.mkBool true ''
          Standalone file support (enabled by default).
          Disabling it may improve rust-analyzer's startup time.
        '';

        logfile =
          helpers.defaultNullOpts.mkNullable (with helpers.nixvimTypes; either str rawLua)
          ''{__raw = "vim.fn.tempname() .. '-rust-analyzer.log'";}''
          "The path to the rust-analyzer log file.";
      };

      dap = {
        autoloadConfigurations = helpers.defaultNullOpts.mkBool true ''
          Whether to autoload nvim-dap configurations when rust-analyzer has attached ?
        '';

        adapter = let
          dapConfig = types.submodule {
            freeformType = with types; attrsOf anything;
            options = {
              # Common options
              type = mkOption {
                type = types.enum ["executable" "server"];
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

                args = helpers.mkNullOrOption (with helpers.nixvimTypes; maybeRaw (listOf str)) ''
                  Its arguments.
                '';
              };
            };
          };
        in
          helpers.mkNullOrStrLuaFnOr
          (
            with types;
              either
              (enum [false])
              dapConfig
          )
          ''
            Defaults to creating the `rt_lldb` adapter, which is a `DapServerConfig` if `codelldb`
            is detected, and a `DapExecutableConfig` if `lldb` is detected.
            Set to `false` to disable.
          '';
      };
    };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    extraPackages =
      optional
      (cfg.rustAnalyzerPackage != null)
      cfg.rustAnalyzerPackage;

    plugins.lsp.postConfig = let
      globalOptions = with cfg;
        {
          tools = with tools; {
            inherit executor;
            on_initialized = onInitialized;
            reload_workspace_from_cargo_toml = reloadWorkspaceFromCargoToml;
            hover_actions = {
              replace_builtin_hover = hoverActions.replaceBuiltinHover;
            };
            float_win_config = floatWinConfig;
            create_graph = {
              inherit
                (crateGraph)
                backend
                output
                full
                ;
              enabled_graphviz_backends = crateGraph.enabledGraphvizBackends;
              inherit (crateGraph) pipe;
            };
            open_url = openUrl;
          };
          server = with server; {
            auto_attach = autoAttach;
            on_attach = onAttach;
            inherit
              cmd
              settings
              standalone
              logfile
              ;
          };
          dap = with dap; {
            autoload_configurations = autoloadConfigurations;
            inherit adapter;
          };
        }
        // cfg.extraOptions;
    in ''
      vim.g.rustaceanvim = ${helpers.toLuaObject globalOptions}
    '';
  };
}
