_: {
  empty = {
    colorschemes.gruvbox-baby.enable = true;
  };

  defaults = {
    colorschemes.gruvbox-baby = {
      enable = true;

      settings = {
        background_color = "medium";
        transparent_mode = 0;
        comment_style = "italic";
        keyword_style = "italic";
        string_style = "nocombine";
        function_style = "bold";
        variable_style = "NONE";
        highlights = { };
        color_overrides = { };
        use_original_palette = 0;
      };
    };
  };

  example = {
    colorschemes.gruvbox-baby = {
      enable = true;

      settings = {
        function_style = "NONE";
        keyword_style = "italic";
        highlights = {
          Normal = {
            fg = "#123123";
            bg = "NONE";
            style = "underline";
          };
        };
        telescope_theme = 1;
        transparent_mode = 1;
      };
    };
  };
}
