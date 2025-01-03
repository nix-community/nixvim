{
  empty = {
    plugins.csvview.enable = true;
  };

  defaults = {
    plugins.csvview = {
      enable = true;

      settings = {
        parser = {
          async_chunksize = 50;
          delimiter = {
            default = ",";
            ft = {
              tsv = "\t";
            };
          };
          quote_char = ''"'';
          comments = [
            "#"
            "--"
            "//"
          ];
        };
        view = {
          min_column_width = 5;
          spacing = 2;
          display_mode = "highlight";
        };
      };
    };
  };

  example = {
    plugins.csvview = {
      enable = true;

      settings = {
        parser.async_chunksize = 30;
        view = {
          spacing = 4;
          display_mode = "border";
        };
      };
    };
  };
}
