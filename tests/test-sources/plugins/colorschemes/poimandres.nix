{
  # Empty configuration
  empty = {
    colorschemes.poimandres.enable = true;
  };

  # All the upstream default options of poimandres
  defaults = {
    colorschemes.poimandres = {
      enable = true;

      boldVertSplit = false;
      darkVariant = "main";
      disableBackground = false;
      disableFloatBackground = false;
      disableItalics = false;
      dimNcBackground = false;

      groups = {
        background = "background2";
        panel = "background3";
        border = "background3";
        comment = "blueGray3";
        link = "blue3";
        punctuation = "blue3";

        error = "pink3";
        hint = "blue1";
        info = "blue3";
        warn = "yellow";

        git_add = "teal1";
        git_change = "blue2";
        git_delete = "pink3";
        git_dirty = "blue4";
        git_ignore = "blueGray1";
        git_merge = "blue2";
        git_rename = "teal3";
        git_stage = "blue1";
        git_text = "teal2";

        headings = {
          h1 = "teal2";
          h2 = "yellow";
          h3 = "pink3";
          h4 = "pink2";
          h5 = "blue1";
          h6 = "blue2";
        };
      };
      highlightGroups = {};
    };
  };
}
