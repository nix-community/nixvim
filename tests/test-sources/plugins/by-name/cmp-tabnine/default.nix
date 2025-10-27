{
  empty = {
    plugins = {
      cmp.enable = true;
      cmp-tabnine.enable = true;
    };
  };

  defaults = {
    plugins = {
      cmp.enable = true;
      cmp-tabnine = {
        enable = true;

        settings = {
          max_lines = 1000;
          max_num_results = 20;
          sort = true;
          run_on_every_keystroke = true;
          snippet_placeholder = "..";
          ignored_file_types.__empty = { };
          min_percent = 0;
        };
      };
    };
  };

  example = {
    plugins = {
      cmp.enable = true;
      cmp-tabnine = {
        enable = true;

        settings = {
          max_lines = 600;
          max_num_results = 10;
          sort = false;
        };
      };
    };
  };
}
