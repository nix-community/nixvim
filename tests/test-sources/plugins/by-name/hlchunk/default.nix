{
  empty = {
    plugins.hlchunk.enable = true;
  };

  defaults = {
    plugins.hlchunk = {
      enable = true;

      # https://github.com/shellRaining/hlchunk.nvim/tree/main?tab=readme-ov-file#setup
      settings =
        let
          modDefaultConfig = {
            enable = false;
            style = { };
            notify = false;
            priority = 0;
            exclude_filetypes = {
              aerial = true;
              dashboard = true;
              # ...
            };
          };
        in
        {
          chunk = modDefaultConfig;
          indent = modDefaultConfig;
          line_num = modDefaultConfig;
          blank = modDefaultConfig;
        };
    };
  };

  example = {
    plugins.hlchunk = {
      enable = true;

      settings = {
        chunk = {
          enable = true;
          use_treesitter = true;
          style.fg = "#91bef0";
          exclude_filetypes = {
            neo-tree = true;
            lazyterm = true;
          };
          chars = {
            horizontal_line = "─";
            vertical_line = "│";
            left_top = "╭";
            left_bottom = "╰";
            right_arrow = "─";
          };
        };
        indent = {
          chars = [ "│" ];
          use_treesitter = false;

          style.fg = "#45475a";
          exclude_filetypes = {
            neo-tree = true;
            lazyterm = true;
          };
        };
        blank.enable = false;
        line_num = {
          use_treesitter = true;
          style = "#91bef0";
        };
      };
    };
  };
}
