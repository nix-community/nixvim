{
  empty = {
    plugins.flit.enable = true;
  };

  defaults = {
    plugins.flit = {
      enable = true;
      settings = {
        keys = {
          f = "f";
          F = "F";
          t = "t";
          T = "T";
        };
        labeled_modes = "v";
        clever_repeat = true;
        multiline = true;
        opts.__empty = { };
      };
    };
  };

  example = {
    plugins.flit = {
      enable = true;
      settings = {
        keys = {
          f = "f";
          F = "F";
          t = "t";
          T = "T";
        };
        labeled_modes = "nv";
        multiline = true;
      };
    };
  };
}
