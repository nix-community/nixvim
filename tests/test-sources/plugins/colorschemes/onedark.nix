{
  empty = {
    colorschemes.onedark.enable = true;
  };

  example = {
    colorschemes.onedark = {
      enable = true;

      settings = {
        colors = {
          bright_orange = "#ff8800";
          green = "#00ffaa";
        };
        highlights = {
          "@keyword".fg = "$green";
          "@string" = {
            fg = "$bright_orange";
            bg = "#00ff00";
            fmt = "bold";
          };
          "@function" = {
            fg = "#0000ff";
            sp = "$cyan";
            fmt = "underline,italic";
          };
          "@function.builtin".fg = "#0059ff";
        };
      };
    };
  };

  defaults = {
    colorschemes.onedark = {
      enable = true;

      settings = {
        style = "dark";
        transparent = false;
        term_colors = true;
        ending_tildes = false;
        cmp_itemkind_reverse = false;
        toggle_style_key.__raw = "nil";
        toggle_style_list = [
          "dark"
          "darker"
          "cool"
          "deep"
          "warm"
          "warmer"
          "light"
        ];
        code_style = {
          comments = "italic";
          keywords = "none";
          functions = "none";
          strings = "none";
          variables = "none";
        };
        lualine = {
          transparent = false;
        };
        colors.__empty = { };
        highlights.__empty = { };
        diagnostics = {
          darker = true;
          undercurl = true;
          background = true;
        };
      };
    };
  };
}
