{
  empty = {
    plugins = {
      telescope.enable = true;
      telekasten.enable = true;
      web-devicons.enable = false;
    };
  };

  example = {
    plugins = {
      telescope.enable = true;
      telekasten = {
        enable = true;
        settings = {
          home.__raw = ''vim.fn.expand("~/zettelkasten")'';
        };
      };
      web-devicons.enable = false;
    };
  };
}
