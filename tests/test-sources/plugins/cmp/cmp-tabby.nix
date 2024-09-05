{
  empty = {
    plugins.cmp = {
      enable = true;
      settings.sources = [ { name = "cmp_tabby"; } ];
    };
  };

  defaults = {
    plugins = {
      cmp = {
        enable = true;
        settings.sources = [ { name = "cmp_tabby"; } ];
      };
      cmp-tabby.settings = {
        host = "http://localhost:5000";
        max_lines = 100;
        run_on_every_keystroke = true;
        stop = [ "\n" ];
      };
    };
  };
}
