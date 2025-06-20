{
  empty = {
    plugins.mini-ai.enable = true;
  };

  example = {
    plugins.mini-ai = {
      enable = true;

      settings = {
        n_lines = 500;
        search_method = "cover_or_nearest";
        silent = true;
      };
    };
  };
}
