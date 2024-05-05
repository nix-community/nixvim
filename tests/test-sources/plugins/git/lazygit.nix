{
  empty = {
    plugins.lazygit.enable = true;
  };

  defaults = {
    plugins.lazygit = {
      enable = true;

      settings = {
        floating_window_winblend = 0;
        floating_window_scaling_factor = 0.9;
        floating_window_border_chars = [
          "╭"
          "─"
          "╮"
          "│"
          "╯"
          "─"
          "╰"
          "│"
        ];
        floating_window_use_plenary = false;
        use_neovim_remote = true;
        use_custom_config_file_path = false;
        config_file_path = [ ];
      };
    };
  };
}
