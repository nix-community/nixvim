{
  empty = {
    plugins.mini-jump.enable = true;
  };

  defaults = {
    plugins.mini-jump = {
      enable = true;
      settings = {
        mappings = {
          forward = "f";
          backward = "F";
          forward_till = "t";
          backward_till = "T";
          repeat_jump = ";";
        };

        delay = {
          highlight = 250;
          idle_stop = 10000000;
        };

        silent = false;
      };
    };
  };
}
