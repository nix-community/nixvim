{
  empty = {
    plugins.direnv.enable = true;
  };

  defaults = {
    plugins.direnv = {
      enable = true;

      settings = {
        direnv_auto = false;
        direnv_edit_mode = "vsplit";
        direnv_silent_load = false;
      };
    };
  };
}
