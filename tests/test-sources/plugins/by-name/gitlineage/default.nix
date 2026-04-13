{
  empty = {
    plugins.gitlineage.enable = true;
  };

  defaults = {
    plugins.gitlineage = {
      enable = true;

      settings = {
        split = "auto";
        keymap = "<leader>gl";
        keys = {
          close = "q";
          next_commit = "]c";
          prev_commit = "[c";
          yank_commit = "yc";
          open_diff = "<CR>";
        };
      };
    };
  };

  example = {
    plugins.gitlineage = {
      enable = true;

      settings = {
        split = "vertical";
        keymap.__raw = "nil";
        keys = {
          close = "q";
          next_commit = "]c";
          prev_commit = "[c";
          yank_commit = "yc";
          open_diff.__raw = "nil";
        };
      };
    };
  };
}
