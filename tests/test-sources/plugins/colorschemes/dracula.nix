{
  empty = {
    colorschemes.dracula.enable = true;
  };

  defaults = {
    colorschemes.dracula = {
      enable = true;

      settings = {
        bold = true;
        italic = true;
        strikethrough = true;
        underline = true;
        undercurl = true;
        full_special_attrs_support = false;
        high_contrast_diff = false;
        inverse = true;
        colorterm = true;
      };
    };
  };

  example = {
    colorschemes.dracula = {
      enable = true;

      settings = {
        italic = false;
        colorterm = false;
      };
    };
  };
}
