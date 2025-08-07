_: {
  empty = {
    colorschemes.gruvbox-material.enable = true;
  };

  defaults = {
    colorschemes.gruvbox-material = {
      enable = true;
      settings = {
        background = "medium";
        foreground = "material";
        transparent_background = 0;
        dim_inactive_windows = 0;
        disable_italic_comment = 0;
        enable_bold = 0;
        enable_italic = 0;
        cursor = "auto";
        visual = "grey background";
        menu_selection_background = "grey";
        sign_column_background = "none";
        spell_foreground = "none";
        ui_contrast = "low";
        show_eob = 1;
        float_style = "bright";
        current_word = "grey background";
        inlay_hints_background = "none";
        statusline_style = "default";
        lightline_disable_bold = 0;
        diagnostic_text_highlight = 0;
        diagnostic_line_highlight = 0;
        diagnostic_virtual_text = "grey";
        disable_terminal_colors = 0;
        better_performance = 0;
      };
    };
  };

  example = {
    colorschemes.gruvbox-material = {
      enable = true;
      settings = {
        foreground = "original";
        enable_bold = 1;
        enable_italic = 1;
        transparent_background = 2;
        colors_override = {
          green = [
            "#7d8618"
            142
          ];
        };
        show_eob = 0;
      };
    };
  };
}
