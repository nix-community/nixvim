{
  empty = {
    colorschemes.palette.enable = true;
  };

  defaults = {
    colorschemes.palette = {
      enable = true;

      settings = {
        palettes = {
          main = "dark";
          accent = "pastel";
          state = "pastel";
        };
        custom_palettes = {
          main = { };
          accent = { };
          state = { };
        };
        italics = true;
        transparent_background = false;
        caching = true;
        cache_dir.__raw = "vim.fn.stdpath('cache') .. '/palette'";
      };
    };
  };

  example-custom-palette = {
    colorschemes.palette = {
      enable = true;

      settings = {
        palettes = {
          main = "dust_dusk";
        };

        custom_palettes = {
          main = {
            dust_dusk = {
              color0 = "#121527";
              color1 = "#1A1E39";
              color2 = "#232A4D";
              color3 = "#3E4D89";
              color4 = "#687BBA";
              color5 = "#A4B1D6";
              color6 = "#bdbfc9";
              color7 = "#DFE5F1";
              color8 = "#e9e9ed";
            };
          };
        };

        italics = true;
        transparent_background = false;
      };
    };
  };
}
