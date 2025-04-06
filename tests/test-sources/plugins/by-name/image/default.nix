{
  empty = {
    # At runtime, the plugin tries to get the size of the terminal which doesn't exist in the
    # headless environment.
    test.runNvim = false;

    plugins.image.enable = true;
  };

  defaults = {
    # At runtime, the plugin tries to get the size of the terminal which doesn't exist in the
    # headless environment.
    test.runNvim = false;

    plugins.image = {
      enable = true;

      settings = {
        backend = "kitty";
        processor = "magick_rock";
        integrations = {
          markdown.enabled = true;
          typst.enabled = true;
          neorg.enabled = true;
          syslang.enabled = true;
          html.enabled = false;
          css.enabled = false;
        };
        max_width = null;
        max_height = null;
        max_width_window_percentage = 100;
        max_height_window_percentage = 50;
        scale_factor = 1.0;
        kitty_method = "normal";
        window_overlap_clear_enabled = false;
        window_overlap_clear_ft_ignore = [
          "cmp_menu"
          "cmp_docs"
          "snacks_notif"
          "scrollview"
          "scrollview_sign"
        ];
        editor_only_render_when_focused = false;
        tmux_show_only_in_active_window = false;
        hijack_file_patterns = [
          "*.png"
          "*.jpg"
          "*.jpeg"
          "*.gif"
          "*.webp"
          "*.avif"
        ];
      };
    };
  };

  example = {
    # At runtime, the plugin tries to get the size of the terminal which doesn't exist in the
    # headless environment.
    test.runNvim = false;

    plugins.image = {
      enable = true;

      settings = {
        backend = "kitty";
        max_width = 100;
        max_height = 12;
        max_height_window_percentage.__raw = "math.huge";
        max_width_window_percentage.__raw = "math.huge";
        window_overlap_clear_enabled = true;
        window_overlap_clear_ft_ignore = [
          "cmp_menu"
          "cmp_docs"
          ""
        ];
      };
    };
  };

  ueberzug-backend = {
    # At runtime, the plugin tries to get the size of the terminal which doesn't exist in the
    # headless environment.
    test.runNvim = false;

    plugins.image = {
      enable = true;
      settings.backend = "ueberzug";
    };
  };

  no-packages = {
    test.runNvim = false;

    dependencies = {
      curl.enable = false;
    };
    plugins.image = {
      enable = true;
      settings.backend = "kitty";
      ueberzugPackage = null;
    };
  };
}
