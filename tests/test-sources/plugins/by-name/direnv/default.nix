{
  empty = {
    plugins.direnv.enable = true;
  };

  defaults = {
    plugins.direnv = {
      enable = true;

      settings = {
        auto = 0;
        edit_mode = "vsplit";
        silent_load = 1;
      };
    };
  };

  no-packages = {
    plugins.direnv.enable = true;

    dependencies.direnv.enable = false;
  };
}
