{
  empty = {
    plugins.smear-cursor.enable = true;
  };

  defaults = {
    plugins.smear-cursor = {
      enable = true;

      settings = {
        smear_between_buffers = true;
        smear_between_neighbor_lines = true;
        smear_to_cmd = true;
        scroll_buffer_space = true;
        legacy_computing_symbols_support = false;
        vertical_bar_cursor = false;
        hide_target_hack = true;
        max_kept_windows = 50;
        windows_zindex = 300;
        filetypes_disabled = [ ];
        time_interval = 17;
        delay_animation_start = 5;
        stiffness = 0.6;
        trailing_stiffness = 0.3;
        trailing_exponent = 2;
        slowdown_exponent = 0;
        distance_stop_animating = 0.1;
        max_slope_horizontal = 0.5;
        min_slope_vertical = 2;
        color_levels = 16;
        gamma = 2.2;
        max_shade_no_matrix = 0.75;
        matrix_pixel_threshold = 0.7;
        matrix_pixel_min_factor = 0.5;
        volume_reduction_exponent = 0.3;
        minimum_volume_factor = 0.7;
        max_length = 25;
        logging_level.__raw = "vim.log.levels.INFO";
        cursor_color = null;
        normal_bg = null;
        transparent_bg_fallback_color = "303030";
        cterm_cursor_colors = [
          240
          241
          242
          243
          244
          245
          246
          247
          248
          249
          250
          251
          252
          253
          254
          255
        ];
        cterm_bg = 235;
      };
    };
  };

  example = {
    plugins.smear-cursor = {
      enable = true;

      settings = {
        stiffness = 0.8;
        trailing_stiffness = 0.5;
        distance_stop_animating = 0.5;
        hide_target_hack = false;
      };
    };
  };
}
