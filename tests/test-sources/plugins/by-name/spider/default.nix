{
  empty = {
    plugins.spider.enable = true;
  };

  example = {
    plugins.spider = {
      enable = true;

      settings.skipInsignificantPunctuation = true;
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
