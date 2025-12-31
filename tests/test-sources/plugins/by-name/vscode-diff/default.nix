{
  empty = {
    plugins.vscode-diff.enable = true;
  };

  defaults = {
    plugins.vscode-diff = {
      enable = true;

      settings = {
        highlights = {
          line_insert = "#2a3325";
          line_delete = "#362c2e";
          char_insert = "#3d4f35";
          char_delete = "#4d3538";
        };
        keymaps = {
          view = {
            next_hunk = "]c";
            prev_hunk = "[c";
            next_file = "]f";
            prev_file = "[f";
          };
          explorer = {
            select = "<CR>";
            hover = "K";
            refresh = "R";
          };
        };
      };
    };
  };

  example = {
    plugins.vscode-diff = {
      enable = true;

      settings = {
        highlights = {
          line_insert = "DiffAdd";
          line_delete = "DiffDelete";
          char_insert.__raw = "nil";
          char_delete.__raw = "nil";
          char_brightness.__raw = "nil";
        };
        diff = {
          disable_inlay_hints = true;
          max_computation_time_ms = 5000;
        };
        explorer = {
          position = "left";
          width = 40;
          height = 15;
          view_mode = "list";
          indent_markers = true;
          icons = {
            folder_closed = "\u{e5ff}";
            folder_open = "\u{e5fe}";
          };
          file_filter = {
            ignore = [ ];
          };
        };
        keymaps = {
          view = {
            quit = "q";
            toggle_explorer = "<leader>b";
            next_hunk = "]c";
            prev_hunk = "[c";
            next_file = "]f";
            prev_file = "[f";
            diff_get = "do";
            diff_put = "dp";
          };
          explorer = {
            select = "<CR>";
            hover = "K";
            refresh = "R";
            toggle_view_mode = "i";
          };
        };
      };
    };
  };
}
