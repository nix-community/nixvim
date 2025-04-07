{
  empty = {
    plugins.direnv.enable = true;
  };

  defaults = {
    plugins.direnv = {
      enable = true;

      settings = {
        direnv_auto = 0;
        direnv_edit_mode = "vsplit";
        direnv_silent_load = 0;
      };
    };
  };

  no-packages = {
    plugins.direnv.enable = true;

    dependencies.direnv.enable = false;
  };
}
