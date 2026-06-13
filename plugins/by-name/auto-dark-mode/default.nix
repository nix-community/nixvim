{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "auto-dark-mode";
  package = "auto-dark-mode-nvim";

  maintainers = [ lib.maintainers.vimlinuz ];

  description = ''
    A Neovim plugin for macOS, Linux & Windows that automatically changes the editor appearance based on system settings.
  '';

  settingsExample = {
    update_interval = 3000;
    fallback = "dark";
    set_dark_mode = ''
      function()
        vim.cmd.colorscheme("tokyonight")
        vim.api.nvim_set_option_value("background", "dark", {})
      end
    '';

    set_light_mode = ''
      function()
        vim.cmd.colorscheme("tokyonight-day")
        vim.api.nvim_set_option_value("background", "light", {})
      end
    '';
  };
}
