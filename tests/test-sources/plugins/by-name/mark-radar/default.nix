{
  empty = {
    plugins.mark-radar.enable = true;
  };

  defaults = {
    plugins.mark-radar = {
      enable = true;

      settings = {
        set_default_mappings = true;
        highlight_group = "RadarMark";
        background_highlight = true;
        background_highlight_group = "RadarBackground";
        text_position = "overlay";
        show_marks_at_jump_positions = true;
        show_off_screen_marks = true;
      };
    };
  };
}
