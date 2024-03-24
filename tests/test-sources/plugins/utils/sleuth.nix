{
  empty = {
    plugins.sleuth.enable = true;
  };

  example = {
    plugins.sleuth = {
      enable = true;

      settings = {
        heuristics = true;
        gitcommit_heuristics = false;
        no_filetype_indent_on = true;
      };
    };
  };
}
