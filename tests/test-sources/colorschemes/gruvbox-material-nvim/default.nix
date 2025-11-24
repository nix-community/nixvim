{ lib }:
{
  empty = {
    colorschemes.gruvbox-material-nvim.enable = true;
  };

  defaults = {
    colorschemes.gruvbox-material-nvim = {
      enable = true;

      settings = {
        italics = true;
        contrast = "medium";
        comments = {
          italics = true;
        };
        background = {
          transparent = false;
        };
        float = {
          force_background = false;
          background_color.__raw = "nil";
        };
        signs = {
          force_background = false;
          background_color.__raw = "nil";
        };
        customize.__raw = "nil";
      };
    };
  };

  example = {
    colorschemes.gruvbox-material-nvim = {
      enable = true;

      settings = {
        italics = true;
        contrast = "medium";
        comments = {
          italics = true;
        };
        background = {
          transparent = false;
        };
        float = {
          force_background = false;
        };
        signs = {
          force_background = false;
          background_color.__raw = "nil";
        };
        customize = lib.nixvim.mkRaw ''
          function(g, o)
            local colors = require("gruvbox-material.colors").get(vim.o.background, "medium")
            if g == "CursorLineNr" then
              o.link = nil            -- wipe a potential link, which would take precedence over other
                                      -- attributes
              o.fg = colors.orange    -- or use any color in "#rrggbb" hex format
              o.bold = true
            end
            return o
          end
        '';
      };
    };
  };
}
