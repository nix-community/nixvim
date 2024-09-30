{
  empty = {
    plugins.wrapping.enable = true;
  };

  defaults = {
    plugins.wrapping = {
      enable = true;
      settings = {
        notify_on_switch = true;
        create_commands = true;
        create_keymaps = false;
        set_nvim_opt_default = true;
      };
    };
  };
}
