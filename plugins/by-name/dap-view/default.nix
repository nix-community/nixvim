{ config, lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dap-view";
  moduleName = "dap-view";
  package = "nvim-dap-view";
  description = "Visualize debugging sessions in Neovim.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    winbar = {
      controls.enabled = true;
    };
    windows.terminal = {
      position = "right";
      start_hidden = true;
    };
  };

  extraConfig = {
    assertions = lib.nixvim.mkAssertions "plugins.dap-view" {
      assertion = config.plugins.dap.enable;
      message = ''
        You have to enable `plugins.dap` to use `plugins.dap-view`.
      '';
    };

    # Compatibility with lualine module.
    # Broken UI otherwise https://github.com/igorlfs/nvim-dap-view/issues/36
    plugins.lualine.settings.options.disabled_filetypes.winbar = [
      "dap-repl"
      "dap-view"
      "dap-view-term"
    ];
  };
}
