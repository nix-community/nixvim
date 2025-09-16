{
  empty = {
    plugins.unified.enable = true;
  };

  defaults = {
    plugins.unified = {
      enable = true;
      settings = {
        signs = {
          add = "│";
          delete = "│";
          change = "│";
        };
        highlights = {
          add = "DiffAdd";
          delete = "DiffDelete";
          change = "DiffChange";
        };
        line_symbols = {
          add = "+";
          delete = "-";
          change = "~";
        };
        auto_refresh = true;
      };
    };
  };
}
