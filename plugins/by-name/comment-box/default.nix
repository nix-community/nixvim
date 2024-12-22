{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "comment-box";
  packPathName = "comment-box.nvim";
  package = "comment-box-nvim";
  description = ''
    Clarify and beautify your comments and plain text files using boxes and lines.
  '';

  maintainers = [ lib.maintainers.elythh ];

  settingsOptions = {
    comment_style =
      defaultNullOpts.mkEnum
        [
          "line"
          "block"
          "auto"
        ]
        "line"
        ''
          Select the type of comments.
        '';

    doc_width = defaultNullOpts.mkInt 80 ''
      Width of the document.
    '';
    box_width = defaultNullOpts.mkInt 60 ''
      Width of the boxes.
    '';

    borders = {
      top = defaultNullOpts.mkStr "─" ''
        Symbol used to draw the top border of a box.
      '';

      bottom = defaultNullOpts.mkStr "─" ''
        Symbol used to draw the bottom border of a box.
      '';

      left = defaultNullOpts.mkStr "│" ''
        Symbol used to draw the left border of a box.
      '';

      right = defaultNullOpts.mkStr "│" ''
        Symbol used to draw the right border of a box.
      '';

      top_left = defaultNullOpts.mkStr "╭" ''
        Symbol used to draw the top left corner of a box.
      '';

      top_right = defaultNullOpts.mkStr "╮" ''
        Symbol used to draw the top right corner of a box.
      '';

      bottom_left = defaultNullOpts.mkStr "╰" ''
        Symbol used to draw the bottom left corner of a box.
      '';

      bottom_right = defaultNullOpts.mkStr "╯" ''
        Symbol used to draw the bottom right corner of a box.
      '';

    };

    line_width = defaultNullOpts.mkInt 70 ''
      Width of the lines.
    '';

    lines = {
      line = defaultNullOpts.mkStr "─" ''
        Symbol used to draw a line.
      '';

      line_start = defaultNullOpts.mkStr "─" ''
        Symbol used to draw the start of a line.
      '';

      line_end = defaultNullOpts.mkStr "─" ''
        Symbol used to draw the end of a line.
      '';

      title_left = defaultNullOpts.mkStr "─" ''
        Symbol used to draw the left border of the title.
      '';

      title_right = defaultNullOpts.mkStr "─" ''
        Symbol used to draw the right border of the title.
      '';

      outer_blank_lines_above = defaultNullOpts.mkBool false ''
        Insert a blank line above the box.
      '';

      outer_blank_lines_below = defaultNullOpts.mkBool false ''
        Insert a blank line below the box.
      '';

      inner_blank_lines = defaultNullOpts.mkBool false ''
        Insert a blank line above and below the text.
      '';

      line_blank_line_above = defaultNullOpts.mkBool false ''
        Insert a blank line above the line.
      '';

      line_blank_line_below = defaultNullOpts.mkBool false ''
        Insert a blank line below the line.
      '';
    };
  };

  settingsExample = {
    comment_style = "block";
    doc_width = 100;
    box_width = 120;
    borders = {
      top_left = "X";
      top_right = "X";
      bottom_left = "X";
      bottom_right = "X";
    };
    line_width = 40;
    lines = {
      line = "*";
    };
    outer_blank_lines_below = true;
    inner_blank_lines = true;
  };
}
