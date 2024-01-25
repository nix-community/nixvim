{
  empty = {
    plugins.nvim-cmp = {
      enable = true;
      sources = [
        {name = "cmp_tabby";}
      ];
    };
  };

  defaults = {
    plugins = {
      nvim-cmp = {
        enable = true;
        sources = [
          {name = "cmp_tabby";}
        ];
      };
      cmp-tabby = {
        host = "http://localhost:5000";
        maxLines = 100;
        runOnEveryKeyStroke = true;
        stop = ["\n"];
      };
    };
  };
}
