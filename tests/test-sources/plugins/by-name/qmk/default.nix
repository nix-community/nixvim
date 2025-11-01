{
  minimal = {
    plugins.qmk = {
      enable = true;
      settings = {
        name = "LAYOUT_preonic_grid";
        layout = [
          "x x"
          "x^x"
        ];
      };
    };
  };

  example = {
    plugins.qmk = {
      enable = true;

      settings = {
        name = "LAYOUT_preonic_grid";
        layout = [
          "x x"
          "x^x"
        ];
        variant = "qmk";
        timeout = 5000;
        auto_format_pattern = "*keymap.c";
        comment_preview = {
          position = "top";
          keymap_overrides.__empty = { };
          symbols = {
            space = " ";
            horz = "─";
            vert = "│";
            tl = "┌";
            tm = "┬";
            tr = "┐";
            ml = "├";
            mm = "┼";
            mr = "┤";
            bl = "└";
            bm = "┴";
            br = "┘";
          };
        };
      };
    };
  };
}
