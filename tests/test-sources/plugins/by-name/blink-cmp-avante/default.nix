{
  empty = {
    plugins = {
      blink-cmp.enable = true;
      blink-cmp-avante.enable = true;
    };
  };

  example = {
    plugins = {
      blink-cmp-avante.enable = true;
      blink-cmp = {
        enable = true;

        settings = {
          sources = {
            default = [
              "avante"
              "lsp"
              "path"
              "buffer"
            ];
            providers = {
              avante = {
                module = "blink-cmp-avante";
                name = "Avante";
                opts = { };
              };
            };
          };
        };
      };
    };
  };
}
