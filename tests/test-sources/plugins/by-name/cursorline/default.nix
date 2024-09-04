{
  empty = {
    plugins.cursorline.enable = true;
  };

  defaults = {
    plugins.cursorline = {
      enable = true;

      cursorline = {
        enable = true;
        timeout = 1000;
        number = false;
      };
      cursorword = {
        enable = true;
        minLength = 3;
        hl = {
          underline = true;
        };
      };
    };
  };
}
