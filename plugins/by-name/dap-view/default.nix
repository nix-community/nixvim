{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dap-view";
  packPathName = "nvim-dap-view";
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
    # Compatibility with lualine module.
    # Broken UI otherwise https://github.com/igorlfs/nvim-dap-view/issues/36
    plugins.lualine.settings.options.disabled_filetypes.winbar = [
      "dap-repl"
      "dap-view"
      "dap-view-term"
    ];
  };
}
