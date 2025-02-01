{
  empty = {
    plugins.cursorline.enable = true;
  };

  defaults = {
    plugins.cursorline = {
      enable = true;

      settings = {
        cursorline = {
          enable = true;
          timeout = 1000;
          number = false;
        };
        cursorword = {
          enable = true;
          min_length = 3;
          hl = {
            underline = true;
          };
        };
      };
    };
  };
}
