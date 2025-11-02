{
  empty = {
    colorschemes.cyberdream.enable = true;
  };

  defaults = {
    colorschemes.cyberdream = {
      enable = true;

      settings = {
        transparent = false;
        italic_comments = false;
        hide_fillchars = false;

        borderless_telescope = true;
        terminal_colors = true;

        theme = {
          highlights.__empty = { };
          colors.__empty = { };
        };
      };
    };
  };

  example = {
    colorschemes.cyberdream = {
      enable = true;

      settings = {
        transparent = false;
        italic_comments = false;
        hide_fillchars = false;

        borderless_telescope = true;
        terminal_colors = true;

        theme = {
          highlights = {
            Comment = {
              fg = "#696969";
              bg = "NONE";
              italic = true;
            };
            SpellBad.fg = "red";
            ErrorMsg = {
              fg = "#000000";
              bg = "#000000";
              undercurl = true;
              italic = true;
            };
          };
          colors = {
            bg = "#000000";
            green = "#00ff00";
            magenta = "#ff00ff";
          };
        };
      };
    };
  };
}
