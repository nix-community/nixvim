{
  empty = {
    colorschemes.poimandres.enable = true;
  };

  defaults = {
    colorschemes.poimandres = {
      enable = true;

      settings = {
        bold_vert_split = false;
        dim_nc_background = false;
        disable_background = false;
        disable_float_background = false;
        disable_italics = false;
        dark_variant = "main";
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
        highlight_groups.__empty = { };
      };
    };
  };
}
