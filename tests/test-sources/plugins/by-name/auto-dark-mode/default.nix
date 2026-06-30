{
  empty = {
    plugins.auto-dark-mode.enable = true;
  };

  defaults = {
    plugins.auto-dark-mode = {
      enable = true;
      settings = {
        enabled = true;
        set_dark_mode.__raw = ''
          function()
            vim.api.nvim_set_option_value("background", "dark", {})
          end
        '';
        set_light_mode.__raw = ''
          function()
            vim.api.nvim_set_option_value("background", "light", {})
          end
        '';
        update_interval = 3000;
        fallback = "dark";
      };
    };
  };
}
