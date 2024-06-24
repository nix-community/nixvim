{
  empty = {
    plugins.codesnap.enable = true;
  };

  defaults = {
    plugins.codesnap = {
      enable = true;

      settings = {
        save_path = null;
        mac_window_bar = true;
        title = "CodeSnap.nvim";
        code_font_family = "CaskaydiaCove Nerd Font";
        watermark_font_family = "Pacifico";
        watermark = "CodeSnap.nvim";
        bg_theme = "default";
        bg_color = null;
        breadcrumbs_separator = "/";
        has_breadcrumbs = false;
        has_line_number = false;
        show_workspace = false;
        min_width = 0;
      };
    };
  };

  example = {
    plugins.codesnap = {
      enable = true;

      settings = {
        save_path = "~/Pictures/Screenshots/";
        mac_window_bar = true;
        title = "CodeSnap.nvim";
        watermark = "";
        breadcrumbs_separator = "/";
        has_breadcrumbs = true;
        has_line_number = false;
      };
    };
  };
}
