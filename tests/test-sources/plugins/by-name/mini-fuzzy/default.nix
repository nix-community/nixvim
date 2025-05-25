{
  empty = {
    plugins.mini-fuzzy.enable = true;
  };

  example = {
    plugins.mini-fuzzy = {
      enable = true;
      settings = {
        cutoff = 50;
      };
    };
  };
}
