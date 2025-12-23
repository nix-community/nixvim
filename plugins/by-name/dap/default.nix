{
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;

  dapHelpers = import ./dapHelpers.nix { inherit lib; };
  inherit (dapHelpers) mkSignOption;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dap";
  package = "nvim-dap";
  description = "Debug Adapter Protocol client implementation for Neovim.";

  maintainers = [ lib.maintainers.khaneliman ];

  # Added 2025-01-26
  deprecateExtraOptions = true;

  extraOptions = {
    adapters = lib.nixvim.mkNullOrOption' {
      type = types.submodule {
        freeformType = types.attrsOf types.rawLua;
        options = {
          executables = dapHelpers.mkAdapterOption "executable" dapHelpers.executableAdapterOption;
          servers = dapHelpers.mkAdapterOption "server" dapHelpers.serverAdapterOption;
          pipes = dapHelpers.mkAdapterOption "pipe" dapHelpers.pipeAdapterOption;
        };
      };
      description = ''
        Debug Adapter Protocol adapters.

        Adapters can be defined as dynamic functions or categorized structured configs.
        See `Example` for usage patterns.
      '';
      example = lib.literalExpression ''
        {
          # Dynamic adapter using raw lua function
          # Useful when adapter type is determined at runtime
          python.__raw = '''
            function(cb, config)
              if config.request == 'attach' then
                local port = (config.connect or config).port
                local host = (config.connect or config).host or '127.0.0.1'
                cb({
                  type = 'server',
                  port = assert(port, '`connect.port` is required for a godot `attach` configuration'),
                  host = host,
                  options = {
                    source_filetype = 'gdscript',
                  },
                })
              else
                cb({
                  type = 'executable',
                  command = 'godot',
                  args = { '--path', config.project_path or vim.fn.getcwd(), '--remote-debug', '127.0.0.1:6006' },
                  options = {
                    source_filetype = 'gdscript',
                  },
                })
              end
            end
          ''';

          # Categorized structured config for executable adapter
          executables.python = {
            command = "python";
            args = [ "-m" "debugpy" ];
          };

          # Categorized structured config for server adapter
          servers.netcoredbg = {
            port = 4711;
            executable.command = "netcoredbg";
          };
        }
      '';
    };

    configurations =
      lib.nixvim.mkNullOrOption (with types; attrsOf (listOf dapHelpers.configurationType))
        ''
          Debugger configurations, see `:h dap-configuration` for more info.
        '';

    signs = lib.nixvim.mkCompositeOption "Signs for dap." {
      dapBreakpoint = mkSignOption "B" "Sign for breakpoints.";

      dapBreakpointCondition = mkSignOption "C" "Sign for conditional breakpoints.";

      dapLogPoint = mkSignOption "L" "Sign for log points.";

      dapStopped = mkSignOption "→" "Sign to indicate where the debuggee is stopped.";

      dapBreakpointRejected = mkSignOption "R" "Sign to indicate breakpoints rejected by the debug adapter.";
    };

    extensionConfigLua = mkOption {
      type = types.lines;
      description = ''
        Extension configuration for dap. Don't use this directly !
      '';
      default = "";
      internal = true;
    };
  };

  # Separate configuration and adapter configurations
  callSetup = false;
  extraConfig =
    cfg:
    let
      options = {
        inherit (cfg) configurations;

        adapters = lib.lists.foldr (x: y: x // y) { } [
          (lib.removeAttrs (cfg.adapters or { }) [
            "executables"
            "servers"
            "pipes"
          ])
          (lib.optionalAttrs (cfg.adapters.executables != null) (
            dapHelpers.processAdapters "executable" cfg.adapters.executables
          ))
          (lib.optionalAttrs (cfg.adapters.servers != null) (
            dapHelpers.processAdapters "server" cfg.adapters.servers
          ))
          (lib.optionalAttrs (cfg.adapters.pipes != null) (
            dapHelpers.processAdapters "pipe" cfg.adapters.pipes
          ))
        ];

        signs = with cfg.signs; {
          DapBreakpoint = dapBreakpoint;
          DapBreakpointCondition = dapBreakpointCondition;
          DapLogPoint = dapLogPoint;
          DapStopped = dapStopped;
          DapBreakpointRejected = dapBreakpointRejected;
        };
      }
      // cfg.settings;
    in
    {
      plugins.dap.luaConfig.content = lib.mkMerge [
        (lib.mkIf (cfg.adapters != null) ''
          require("dap").adapters = ${lib.nixvim.toLuaObject options.adapters}
        '')
        (lib.mkIf (options.configurations != null) ''
          require("dap").configurations = ${lib.nixvim.toLuaObject options.configurations}
        '')
        (lib.mkIf (cfg.signs != null) ''
          do
            local __dap_signs = ${lib.nixvim.toLuaObject options.signs}

            for sign_name, sign in pairs(__dap_signs) do
              vim.fn.sign_define(sign_name, sign)
            end
          end
        '')
        ''
          ${cfg.extensionConfigLua}
        ''
      ];
    };
}
