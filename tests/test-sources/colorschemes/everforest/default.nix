{
  empty = {
    colorschemes.everforest.enable = true;
  };

  defaults = {
    colorschemes.everforest = {
      enable = true;

      settings = {
        background = "medium";
        enable_italic = 0;
        disable_italic_comment = 0;
        cursor = "auto";
        transparent_background = 0;
        dim_inactive_windows = 0;
        sign_column_background = "none";
        spell_foreground = "none";
        ui_contrast = "low";
        show_eob = 1;
        float_style = "bright";
        diagnostic_text_highlight = 0;
        diagnostic_line_highlight = 0;
        diagnostic_virtual_text = "grey";
        current_word = "grey background";
        inlay_hints_background = "none";
        disable_terminal_colors = 0;
        lightline_disable_bold = 0;
        colors_override.__raw = "nil";

        # This option is broken when set to 1, because the plugin tries to write its cache in /nix/store
        better_performance = 0;
      };
    };
  };

  nonDefaults = {
    colorschemes.everforest = {
      enable = true;

      settings = {
        background = "hard";
        enable_italic = 1;
        disable_italic_comment = 1;
        cursor = "red";
        transparent_background = 1;
        dim_inactive_windows = 1;
        sign_column_background = "grey";
        spell_foreground = "colored";
        ui_contrast = "high";
        show_eob = 0;
        float_style = "dim";
        diagnostic_text_highlight = 1;
        diagnostic_line_highlight = 1;
        diagnostic_virtual_text = "colored";
        current_word = "bold";
        inlay_hints_background = "dimmed";
        disable_terminal_colors = 1;
        lightline_disable_bold = 1;

        # This option is broken, because the plugin tries to write its cache in /nix/store
        # better_performance = 1;

        colors_override = {
          bg0 = [
            "#202020"
            "234"
          ];
          bg2 = [
            "#282828"
            "235"
          ];
        };
      };
    };
  };
}
