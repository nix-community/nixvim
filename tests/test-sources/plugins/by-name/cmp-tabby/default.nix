{
  empty = {
    plugins.cmp.enable = true;
    plugins.cmp-tabby.enable = true;
  };

  defaults = {
    plugins = {
      cmp = {
        enable = true;
      };
      cmp-tabby.enable = true;
      cmp-tabby.settings = {
        host = "http://localhost:5000";
        max_lines = 100;
        run_on_every_keystroke = true;
        stop = [ "\n" ];
      };
    };
  };
}
