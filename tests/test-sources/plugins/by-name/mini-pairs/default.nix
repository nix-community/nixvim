{
  empty = {
    plugins.mini-pairs.enable = true;
  };

  example = {
    plugins.mini-pairs = {
      enable = true;
      settings = {
        modes = {
          insert = true;
          command = true;
          terminal = false;
        };
      };
    };
  };
}
