{
  empty = {
    plugins.wezterm.enable = true;
  };

  defaults = {
    plugins.wezterm = {
      enable = true;

      settings = {
        create_commands = true;
      };
    };
  };
}
