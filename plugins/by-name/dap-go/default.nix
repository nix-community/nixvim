{
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;

  dapHelpers = import ../dap/dapHelpers.nix { inherit lib; };
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dap-go";
  package = "nvim-dap-go";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    dap_configurations = lib.nixvim.mkNullOrOption (types.listOf dapHelpers.configurationType) ''
      Additional dap configurations.
      See `:h dap-configuration` for more detail.
    '';

    delve = {
      path = defaultNullOpts.mkStr "dlv" "The path to the executable dlv which will be used for debugging.";

      initialize_timeout_sec = defaultNullOpts.mkUnsignedInt 20 "Time to wait for delve to initialize the debug session.";

      port = defaultNullOpts.mkStr "$${port}" ''
        A string that defines the port to start delve debugger.

        Defaults to string "$${port}" which instructs dap
        to start the process in a random available port.
      '';

      args = lib.nixvim.mkNullOrOption (types.listOf types.str) "Additional args to pass to dlv.";

      build_flags = defaultNullOpts.mkStr "" "Build flags to pass to dlv.";
    };
  };

  # Manually supplied to nvim-dap config module
  callSetup = false;
  extraConfig = cfg: {
    plugins.dap = {
      enable = true;
      extensionConfigLua = ''
        require("dap-go").setup(${lib.nixvim.toLuaObject cfg.settings})
      '';
    };
  };
  # NOTE: Renames added in https://github.com/nix-community/nixvim/pull/2897 (2025-01-26)
  imports = [ ./deprecations.nix ];
}
