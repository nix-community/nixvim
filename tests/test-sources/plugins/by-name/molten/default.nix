{
  empty = {
    plugins.molten.enable = true;
  };

  defaults = {
    plugins.molten = {
      enable = true;

      settings = {
        auto_image_popup = false;
        auto_init_behavior = "init";
        auto_open_html_in_browser = false;
        auto_open_output = true;
        cover_empty_lines = false;
        cover_lines_starting_with.__empty = { };
        copy_output = false;
        enter_output_behavior = "open_then_enter";
        image_provider = "none";
        open_cmd.__raw = "nil";
        output_crop_border = true;
        output_show_more = false;
        output_virt_lines = false;
        output_win_border = [
          ""
          "━"
          ""
          ""
        ];
        output_win_cover_gutter = true;
        output_win_hide_on_leave = true;
        output_win_max_height = 999999;
        output_win_max_width = 999999;
        output_win_style = false;
        save_path.__raw = "vim.fn.stdpath('data')..'/molten'";
        tick_rate = 500;
        use_border_highlights = false;
        limit_output_chars = 1000000;
        virt_lines_off_by_1 = false;
        virt_text_output = false;
        virt_text_max_lines = 12;
        wrap_output = false;
        show_mimetype_debug = false;
      };
    };
  };

  example = {
    plugins.molten = {
      enable = true;

      settings = {
        auto_open_output = true;
        copy_output = false;
        enter_output_behavior = "open_then_enter";
        image_provider = "none";
        output_crop_border = true;
        output_show_more = false;
        output_virt_lines = false;
        output_win_border = [
          ""
          "━"
          ""
          ""
        ];
        output_win_cover_gutter = true;
        output_win_hide_on_leave = true;
        output_win_style = false;
        save_path.__raw = "vim.fn.stdpath('data')..'/molten'";
        use_border_highlights = false;
        virt_lines_off_by1 = false;
        wrap_output = false;
        show_mimetype_debug = false;
      };
    };
  };
}
