{
  empty = {
    colorschemes.tokyonight.enable = true;
  };

  defaults = {
    colorschemes.tokyonight = {
      enable = true;

      settings = {
        style = "storm";
        light_style = "day";
        transparent = false;
        terminal_colors = true;
        styles = {
          comments.italic = true;
          keywords.italic = true;
          functions.__empty = { };
          variables.__empty = { };
          sidebars = "dark";
          floats = "dark";
        };
        sidebars = [
          "qf"
          "help"
        ];
        day_brightness = 0.3;
        hide_inactive_statusline = false;
        dim_inactive = false;
        lualine_bold = false;
        on_colors = "function(colors) end";
        on_highlights = "function(highlights, colors) end";
      };
    };
  };
}
