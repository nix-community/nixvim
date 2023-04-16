{
  empty = {
    plugins.spider.enable = true;
  };

  example = {
    plugins.spider = {
      enable = true;

      skipInsignificantPunctuation = true;
      keymaps = {
        silent = true;
        motions = {
          w = "w";
          e = "e";
          b = "b";
          g = "ge";
        };
      };
    };
  };
}
