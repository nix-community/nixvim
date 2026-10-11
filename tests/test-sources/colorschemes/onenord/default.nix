{
  empty = {
    colorschemes.onenord.enable = true;
  };

  defaults = {
    colorschemes.onenord = {
      enable = true;
      settings = {
        borders = true;
        fade_nc = false;

        styles = {
          comments = "NONE";
          strings = "NONE";
          keywords = "NONE";
          functions = "NONE";
          variables = "NONE";
          diagnostics = "underline";
        };

        disable = {
          background = false;
          float_background = false;
          cursorline = false;
          eob_lines = true;
        };

        inverse.match_paren = false;
      };
    };
  };

  example = {
    colorschemes.onenord = {
      enable = true;
      settings = {
        theme = "light";

        custom_highlights = {
          "@constructor" = {
            fg = "#5E81AC";
            style = "bold";
          };
        };

        custom_colors = {
          red = "#ffffff";
        };
      };
    };
  };
}
