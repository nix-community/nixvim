{
  empty = {
    plugins.muren.enable = true;
  };

  defaults = {
    plugins.muren = {
      enable = true;

      settings = {
        create_commands = true;
        filetype_in_preview = true;
        two_step = false;
        all_on_line = true;
        preview = true;
        cwd = false;
        files = "**/*";
        keys = {
          close = "q";
          toggle_side = "<Tab>";
          toggle_options_focus = "<C-s>";
          toggle_option_under_cursor = "<CR>";
          scroll_preview_up = "<Up>";
          scroll_preview_down = "<Down>";
          do_replace = "<CR>";
          do_undo = "<localleader>u";
          do_redo = "<localleader>r";
        };
        patterns_width = 30;
        patterns_height = 10;
        options_width = 20;
        preview_height = 12;
        anchor = "center";
        vertical_offset = 0;
        horizontal_offset = 0;
        order = [

          "buffer"
          "dir"
          "files"
          "two_step"
          "all_on_line"
          "preview"
        ];
        hl = {
          options = {
            on = "@string";
            off = "@variable.builtin";
          };
          preview = {
            cwd = {
              path = "Comment";
              lnum = "Number";
            };
          };
        };
      };
    };
  };

  example = {
    plugins.muren = {
      enable = true;

      settings = {
        create_commands = true;
        filetype_in_preview = true;
      };
    };
  };
}
