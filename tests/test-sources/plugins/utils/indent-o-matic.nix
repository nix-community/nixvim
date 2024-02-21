{
  empty = {
    plugins.indent-o-matic.enable = true;
  };

  example = {
    plugins.indent-o-matic = {
      enable = true;

      settings = {
        max_lines = 2048;
        skip_multiline = false;
        standard_widths = [2 4 8];
      };
    };
  };
}
