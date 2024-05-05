{
  empty = {
    plugins.cmp = {
      enable = true;
      settings.sources = [{name = "cmp_tabby";}];
    };
  };

  defaults = {
    plugins = {
      cmp = {
        enable = true;
        settings.sources = [{name = "cmp_tabby";}];
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
