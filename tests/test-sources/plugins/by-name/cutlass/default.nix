{
  empty = {
    plugins.cutlass-nvim.enable = true;
  };

  defaults = {
    plugins.cutlass-nvim = {
      enable = true;
      settings = {
        cut_key = "nil";
        override_del = "nil";
        exclude.__empty = { };
        registers = {
          select = "_";
          delete = "_";
          change = "_";
        };
      };
    };
  };

  example = {
    plugins.cutlass-nvim = {
      enable = true;
      settings = {
        override_del = true;
        exclude = [
          "ns"
          "nS"
          "nx"
          "nX"
          "nxx"
          "nX"
        ];
        registers = {
          select = "s";
          delete = "d";
          change = "c";
        };
      };
    };
  };
}
