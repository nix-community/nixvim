{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;

  cfg = config.plugins.dap.extensions.dap-go;
  dapHelpers = import ./dapHelpers.nix { inherit lib; };
in
{
  options.plugins.dap.extensions.dap-go = {
    enable = lib.mkEnableOption "dap-go";

    package = lib.mkPackageOption pkgs "dap-go" {
      default = [
        "vimPlugins"
        "nvim-dap-go"
      ];
    };

    dapConfigurations = lib.nixvim.mkNullOrOption (types.listOf dapHelpers.configurationOption) ''
      Additional dap configurations.
      See `:h dap-configuration` for more detail.
    '';

    delve = {
      path = defaultNullOpts.mkStr "dlv" "The path to the executable dlv which will be used for debugging.";

      initializeTimeoutSec = defaultNullOpts.mkInt 20 "Time to wait for delve to initialize the debug session.";

      port = defaultNullOpts.mkStr "$\{port}" ''
        A string that defines the port to start delve debugger.
        Defaults to string "$\{port}" which instructs dap
        to start the process in a random available port.
      '';

      args = lib.nixvim.mkNullOrOption (types.listOf types.str) "Additional args to pass to dlv.";

      buildFlags = defaultNullOpts.mkStr "" "Build flags to pass to dlv.";
    };
  };

  config =
    let
      options = with cfg; {
        dap_configurations = dapConfigurations;

        delve = with delve; {
          inherit path port args;
          initialize_timeout_sec = initializeTimeoutSec;
          build_flags = buildFlags;
        };
      };
    in
    lib.mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      plugins.dap = {
        enable = true;
        extensionConfigLua = ''
          require("dap-go").setup(${lib.nixvim.toLuaObject options})
        '';
      };
    };
}
