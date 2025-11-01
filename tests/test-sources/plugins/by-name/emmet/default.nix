{
  empty = {
    plugins.emmet.enable = true;
  };

  example = {
    plugins.emmet = {
      enable = true;

      settings = {
        mode = "inv";
        leader = "<C-Z>";
        settings = {
          variables = {
            lang = "ja";
          };
          html = {
            default_attributes = {
              option = {
                value.__raw = "nil";
              };
              textarea = {
                id.__raw = "nil";
                name.__raw = "nil";
                cols = 10;
                rows = 10;
              };
            };
            snippets = {
              "html:5" = ''
                <!DOCTYPE html>
                <html lang=\"$\{lang}\">
                <head>
                \t<meta charset=\"$\{charset}\">
                \t<title></title>
                \t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
                </head>
                <body>\n\t$\{child}|\n</body>
                </html>
              '';
            };
          };
        };
      };
    };
  };
}
