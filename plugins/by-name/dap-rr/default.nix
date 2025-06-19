{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dap-rr";
  packPathName = "nvim-dap-rr";
  package = "nvim-dap-rr";
  description = "Dap configuration for the record and replay debugger.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    mappings =
      defaultNullOpts.mkAttrsOf types.str
        {
          continue = "<F7>";
          step_over = "<F8>";
          step_out = "<F9>";
          step_into = "<F10>";
          reverse_continue = "<F19>";
          reverse_step_over = "<F20>";
          reverse_step_out = "<F21>";
          reverse_step_into = "<F22>";
          step_over_i = "<F32>";
          step_out_i = "<F33>";
          step_into_i = "<F34>";
          reverse_step_over_i = "<F44>";
          reverse_step_out_i = "<F45>";
          reverse_step_into_i = "<F46>";
        }
        ''
          Keyboard mappings for nvim-dap-rr.
        '';
  };

  settingsExample = {
    mappings = {
      continue = "<f4>";
      step_over = "<f10>";
      step_out = "<f8>";
      step_into = "<f11>";
      reverse_continue = "<f4>";
      reverse_step_over = "<s-f10>";
      reverse_step_out = "<s-f8>";
      reverse_step_into = "<s-f11>";
    };
  };

  # Manually supplied to nvim-dap config module
  callSetup = false;
  extraConfig = cfg: {
    plugins.dap = {
      enable = true;
      extensionConfigLua = ''
        require("nvim-dap-rr").setup(${lib.nixvim.toLuaObject cfg.settings})
      '';
      configurations = {
        rust = lib.mkDefault [ { __raw = "require('nvim-dap-rr').get_rust_config()"; } ];
        cpp = lib.mkDefault [ { __raw = "require('nvim-dap-rr').get_config()"; } ];
      };
    };
  };
}
