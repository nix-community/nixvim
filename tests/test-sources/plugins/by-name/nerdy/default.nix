{
  empty = {
    plugins.nerdy.enable = true;
  };

  with-telescope = {
    plugins = {
      telescope.enable = true;
      web-devicons.enable = true;

      nerdy = {
        enable = true;
        enableTelescope = true;
      };
    };
  };
}
