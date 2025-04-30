{
  empty = {
    plugins.indent-tools.enable = true;
  };

  defaults = {
    plugins.indent-tools = {
      enable = true;

      settings = {
        normal = {
          up = "[i";
          down = "]i";
          repeatable = true;
        };
        textobj = {
          ii = "ii";
          ai = "ai";
        };
      };
    };
  };

  example = {
    plugins.indent-tools = {
      enable = true;

      settings = {
        textobj = {
          ii = "iI";
          ai = "aI";
        };
        normal = {
          up = false;
          down = false;
        };
      };
    };
  };
}
