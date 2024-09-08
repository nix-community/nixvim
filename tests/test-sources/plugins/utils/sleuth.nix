{
  empty = {
    plugins.sleuth.enable = true;
  };

  example = {
    plugins.sleuth = {
      enable = true;

      settings = {
        heuristics = 1;
        gitcommit_heuristics = 0;
        no_filetype_indent_on = 1;
      };
    };
  };
}
