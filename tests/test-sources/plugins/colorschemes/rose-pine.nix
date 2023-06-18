{
  empty = {
    colorschemes.rose-pine.enable = true;
  };

  defaults = {
    colorschemes.rose-pine = {
      enable = true;

      style = "main";

      boldVerticalSplit = false;
      dimInactive = false;
      disableItalics = false;

      groups = {
        background = "base";
        background_nc = "_experimental_nc";
        panel = "surface";
        panel_nc = "base";
        border = "highlight_med";
        comment = "muted";
        link = "iris";
        punctuation = "subtle";

        error = "love";
        hint = "iris";
        info = "foam";
        warn = "gold";

        headings = {
          h1 = "iris";
          h2 = "foam";
          h3 = "rose";
          h4 = "gold";
          h5 = "pine";
          h6 = "foam";
        };
      };

      highlightGroups = {
        ColorColumn = {bg = "rose";};

        CursorLine = {
          bg = "foam";
          blend = 10;
        };
        StatusLine = {
          fg = "love";
          bg = "love";
          blend = 10;
        };
      };

      transparentBackground = false;
      transparentFloat = false;
    };
  };
}
