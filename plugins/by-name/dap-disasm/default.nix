{ config, lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dap-disasm";
  package = "nvim-dap-disasm";
  description = "Disassembly view for nvim-dap";

  maintainers = [ lib.maintainers.zainkergaye ];

  settingsExample = {
    dapui_register = true;
    dapview_register = true;
    winbar = {
      enabled = true;
      labels = {
        step_into = "Step Into";
        step_over = "Step Over";
        step_back = "Step Back";
      };
      order = [
        "step_into"
        "step_over"
        "step_back"
      ];
    };

    sign = "DapStopped";

    ins_before_memref = 16;
    ins_after_memreg = 16;

    columns = [
      "address"
      "instructionBytes"
      "instruction"
    ];
  };

  extraConfig = {
    assertions = lib.nixvim.mkAssertions "plugins.dap-disasm" {
      assertion = config.plugins.dap.enable;
      message = ''
        You have to enable `plugins.dap` to use `plugins.dap-disasm`.
      '';
    };
  };
}
