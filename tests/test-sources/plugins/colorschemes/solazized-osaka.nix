{ lib, ... }:
{
  empty = {
    colorschemes.solarized-osaka.enable = true;
  };

  defaults = {
    colorschemes.solarized-osaka = {
      enable = true;

      settings = {
        transparent = true;
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
        on_colors = lib.nixvim.mkRaw "function(colors) end";
        on_highlights = lib.nixvim.mkRaw "function(highlights, colors) end";
      };
    };
  };

  example = {
    colorschemes.solarized-osaka = {
      enable = true;

      settings = {
        transparent = false;
        styles = {
          comments.italic = true;
          keywords.italic = false;
          floats = "transparent";
        };
      };
    };
  };
}
