{
  empty = {
    colorschemes.monokai-pro.enable = true;
  };

  defaults = {
    plugins.web-devicons.enable = true;
    colorschemes.monokai-pro = {
      enable = true;

      settings = {
        transparent_background = false;
        terminal_colors = true;
        devicons = false;
        styles = {
          comment.italic = true;
          keyword.italic = true;
          type.italic = true;
          storageclass.italic = true;
          structure.italic = true;
          parameter.italic = true;
          annotation.italic = true;
          tag_attribute.italic = true;
        };
        filter.__raw = "vim.o.background == 'light' and 'classic' or 'pro'";
        day_night = {
          enable = false;
          day_filter = "pro";
          night_filter = "spectrum";
        };
        inc_search = "background";
        background_clear = [
          "toggleterm"
          "telescope"
          "renamer"
          "notify"
        ];
        plugins = {
          bufferline = {
            underline_selected = false;
            underline_visible = false;
            underline_fill = false;
            bold = true;
          };
          indent_blankline = {
            context_highlight = "default";
            context_start_underline = false;
          };
        };
      };
    };
  };

  example = {
    colorschemes.monokai-pro = {
      enable = true;

      settings = {
        terminal_colors = false;
        devicons = false;
        filter = "ristretto";
      };
    };
  };
}
