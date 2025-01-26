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
  imports = [
    ./dap-python.nix
    ./dap-ui.nix
    ./dap-virtual-text.nix
  ];

  name = "dap";
  package = "nvim-dap";
  packPathName = "nvim-dap";

  maintainers = [ lib.maintainers.khaneliman ];

  # Added 2025-01-26
  deprecateExtraOptions = true;

  extraOptions = {
    adapters = lib.nixvim.mkCompositeOption "Dap adapters." {
      executables = dapHelpers.mkAdapterOption "executable" dapHelpers.executableAdapterOption;
      servers = dapHelpers.mkAdapterOption "server" dapHelpers.serverAdapterOption;
    };

    configurations =
      lib.nixvim.mkNullOrOption (with types; attrsOf (listOf dapHelpers.configurationOption))
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

        adapters =
          (lib.optionalAttrs (cfg.adapters.executables != null) (
            dapHelpers.processAdapters "executable" cfg.adapters.executables
          ))
          // (lib.optionalAttrs (cfg.adapters.servers != null) (
            dapHelpers.processAdapters "server" cfg.adapters.servers
          ));

        signs = with cfg.signs; {
          DapBreakpoint = dapBreakpoint;
          DapBreakpointCondition = dapBreakpointCondition;
          DapLogPoint = dapLogPoint;
          DapStopped = dapStopped;
          DapBreakpointRejected = dapBreakpointRejected;
        };
      } // cfg.settings;
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
