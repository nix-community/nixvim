{
  empty = {
    plugins.improved-search.enable = true;
  };

  example = {
    plugins.improved-search = {
      enable = true;

      keymaps = [
        {
          mode = [
            "n"
            "x"
            "o"
          ];
          key = "n";
          action = "stable_next";
        }
        {
          mode = [
            "n"
            "x"
            "o"
          ];
          key = "N";
          action = "stable_previous";
        }
        {
          mode = "n";
          key = "!";
          action = "current_word";
        }
        {
          mode = "x";
          key = "!";
          action = "in_place";
        }
        {
          mode = "x";
          key = "*";
          action = "forward";
        }
        {
          mode = "x";
          key = "#";
          action = "backward";
        }
        {
          mode = "n";
          key = "|";
          action = "in_place";
        }
      ];
    };
  };
}
