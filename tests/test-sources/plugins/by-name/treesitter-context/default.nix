{
  empty = {
    plugins = {
      treesitter.enable = true;
      treesitter-context.enable = true;
    };
  };

  default = {
    plugins = {
      treesitter.enable = true;
      treesitter-context = {
        enable = true;

        settings = {
          enable = true;
          max_lines = 0;
          min_window_height = 0;
          line_numbers = true;
          multiline_threshold = 20;
          trim_scope = "outer";
          mode = "cursor";
          separator.__raw = "nil";
          zindex = 20;
          on_attach = "nil";
        };
      };
    };
  };
}
