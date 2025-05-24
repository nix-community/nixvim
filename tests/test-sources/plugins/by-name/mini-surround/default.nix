{
  empty = {
    plugins.mini-surround.enable = true;
  };

  example = {
    plugins.mini-surround = {
      enable = true;

      settings = {
        n_lines = 50;
        respect_selection_type = true;
        search_method = "cover_or_next";
      };
    };
  };
}
