{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    optionalString
    types
    ;

  cfg = config.plugins.dap;

  dapHelpers = import ./dapHelpers.nix { inherit lib; };
  inherit (dapHelpers) mkSignOption;
in
{
  imports = [
    ./dap-go.nix
    ./dap-python.nix
    ./dap-ui.nix
    ./dap-virtual-text.nix
  ];

  options.plugins.dap = lib.nixvim.plugins.neovim.extraOptionsOptions // {
    enable = mkEnableOption "dap";

    package = lib.mkPackageOption pkgs "dap" {
      default = [
        "vimPlugins"
        "nvim-dap"
      ];
    };

    adapters = lib.nixvim.mkCompositeOption "Dap adapters." {
      executables = dapHelpers.mkAdapterOption "executable" dapHelpers.executableAdapterOption;
      servers = dapHelpers.mkAdapterOption "server" dapHelpers.serverAdapterOption;
    };

    configurations =
      lib.nixvim.mkNullOrOption (with types; attrsOf (listOf dapHelpers.configurationOption))
        ''
          Debuggee configurations, see `:h dap-configuration` for more info.
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

  config =
    let
      options =
        with cfg;
        {
          inherit configurations;

          adapters =
            (lib.optionalAttrs (adapters.executables != null) (
              dapHelpers.processAdapters "executable" adapters.executables
            ))
            // (lib.optionalAttrs (adapters.servers != null) (
              dapHelpers.processAdapters "server" adapters.servers
            ));

          signs = with signs; {
            DapBreakpoint = dapBreakpoint;
            DapBreakpointCondition = dapBreakpointCondition;
            DapLogPoint = dapLogPoint;
            DapStopped = dapStopped;
            DapBreakpointRejected = dapBreakpointRejected;
          };
        }
        // cfg.extraOptions;
    in
    lib.mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua =
        (optionalString (cfg.adapters != null) ''
          require("dap").adapters = ${lib.nixvim.toLuaObject options.adapters}
        '')
        + (optionalString (options.configurations != null) ''
          require("dap").configurations = ${lib.nixvim.toLuaObject options.configurations}
        '')
        + (optionalString (cfg.signs != null) ''
          local __dap_signs = ${lib.nixvim.toLuaObject options.signs}
          for sign_name, sign in pairs(__dap_signs) do
            vim.fn.sign_define(sign_name, sign)
          end
        '')
        + cfg.extensionConfigLua;
    };
}
