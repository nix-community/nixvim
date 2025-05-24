{
  empty = {
    plugins.mini-icons.enable = true;
  };

  example = {
    plugins.mini-icons = {
      enable = true;

      settings = {
        style = "glyph";
        extension = {
          lua = {
            hl = "Special";
          };
        };
        file = {
          "init.lua" = {
            glyph = "";
            hl = "MiniIconsGreen";
          };
        };
      };
    };
  };
}
