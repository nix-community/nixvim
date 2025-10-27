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
        floating_window_use_plenary = 0;
        use_neovim_remote = 1;
        use_custom_config_file_path = 0;
        config_file_path.__empty = { };
      };
    };
  };
}
