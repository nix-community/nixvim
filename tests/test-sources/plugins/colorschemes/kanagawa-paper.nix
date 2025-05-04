{
  empty = {
    # disable test due to this error: ERROR: Cache updated: kanagawa-paper-plugins.json
    # initial assessment was to disable cache via plugin config but that did not work
    # then disabled the plugins loading on auto and that did not work either, might be a runtime setup
    test.runNvim = false;
    colorschemes.kanagawa-paper.enable = true;
  };

  defaults = {
    test.runNvim = false;
    colorschemes.kanagawa-paper = {
      enable = true;

      settings = {
        cache = false;
        colors = {
          palette = { };
          theme = {
            ink = { };
            canvas = { };
          };
        };
        undercurl = true;
        styles = {
          comments = {
            italic = true;
          };
          functions = {
            italic = true;
          };
          keywords = {
            italic = true;
          };
          statement_style = {
            bold = true;
          };
        };
        transparent = true;
        auto_plugins = false;
        dim_inactive = false;
        terminal_colors = false;
        gutter = false;
        theme = "ink";
      };
    };
  };
}
