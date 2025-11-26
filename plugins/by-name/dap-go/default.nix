{
  config,
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dap-go";
  package = "nvim-dap-go";
  description = "An extension for nvim-dap providing configurations for launching go debugger.";

  maintainers = [ lib.maintainers.khaneliman ];

  # Manually supplied to nvim-dap config module
  callSetup = false;
  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "plugins.dap-go" {
      assertion = config.plugins.dap.enable;
      message = ''
        You have to enable `plugins.dap` to use `plugins.dap-go`.
      '';
    };

    plugins.dap.extensionConfigLua = ''
      require("dap-go").setup(${lib.nixvim.toLuaObject cfg.settings})
    '';
  };
  # NOTE: Renames added in https://github.com/nix-community/nixvim/pull/2897 (2025-01-26)
  imports = [ ./deprecations.nix ];
}
