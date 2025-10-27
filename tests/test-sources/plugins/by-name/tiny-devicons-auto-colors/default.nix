{
  empty = {
    plugins = {
      web-devicons.enable = true;
      tiny-devicons-auto-colors.enable = true;
    };
  };

  defaults = {
    plugins = {
      web-devicons.enable = true;
      tiny-devicons-auto-colors = {
        enable = true;

        settings = {
          colors.__raw = "nil";
          factors = {
            lightness = 1.75;
            chroma = 1;
            hue = 1.25;
          };
          cache = {
            enabled = true;
            path.__raw = ''vim.fn.stdpath("cache") .. "/tiny-devicons-auto-colors-cache.json"'';
          };
          precise_search = {
            enabled = true;
            iteration = 10;
            precision = 20;
            threshold = 23;
          };
          ignore.__empty = { };
          autoreload = false;
        };
      };
    };
  };

  catppuccin = {
    colorschemes.catppuccin.enable = true;
    plugins = {
      web-devicons.enable = true;
      tiny-devicons-auto-colors = {
        enable = true;

        settings = {
          colors.__raw = ''require("catppuccin.palettes").get_palette("macchiato")'';
        };
      };
    };
  };

  mini = {
    plugins = {
      mini = {
        enable = true;
        mockDevIcons = true;
        modules.icons = { };
      };
      tiny-devicons-auto-colors.enable = true;
    };
  };
}
