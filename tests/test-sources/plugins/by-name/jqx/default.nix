{
  empty = {
    plugins.jqx.enable = true;
  };

  defaults = {
    plugins.jqx = {
      enable = true;
      settings = {
        geometry = {
          border = "single";
          width = 0.7;
        };
        query_key = "X";
        sort = false;
        show_legend = true;
        use_quickfix = false;
      };
    };
  };
}
