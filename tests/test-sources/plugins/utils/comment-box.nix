_: {
  empty = {
    plugins.comment-box.enable = true;
  };

  defaults = {
    plugins.comment-box = {
      enable = true;

      settings = {
        comment_style = "line";
        doc_width = 80;
        box_width = 60;
        borders = {
          top = "─";
          bottom = "─";
          left = "│";
          right = "│";
          top_left = "╭";
          top_right = "╮";
          bottom_left = "╰";
          bottom_right = "╯";
        };
        line_width = 70;
        lines = {
          line = "─";
          line_start = "─";
          line_end = "─";
          title_left = "─";
          title_right = "─";
        };
        outer_blank_lines_above = false;
        outer_blank_lines_below = false;
        inner_blank_lines = false;
        line_blank_line_above = false;
        line_blank_line_below = false;
      };
    };
  };
}
