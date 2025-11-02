{
  empty = {
    colorschemes.modus.enable = true;
  };

  defaults = {
    colorschemes.modus = {
      enable = true;

      settings = {
        style = "modus_operandi";
        variant = "default";
        transparent = false;
        dim_inactive = false;
        hide_inactive_statusline = false;
        styles = {
          comments.italic = true;
          keywords.italic = true;
          functions.__empty = { };
          variables.__empty = { };
        };
        on_colors = "function(colors) end";
        on_highlights = "function(highlights, colors) end";
      };
    };
  };
}
