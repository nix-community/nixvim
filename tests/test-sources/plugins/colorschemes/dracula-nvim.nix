{
  empty = {
    plugins.dracula.enable = true;
  };

  default = {
    plugins.dracula = {
      enable = true;
    };
  };

  example = {
    plugins.dracula = {
      enable = true;
      settings = {
        italic_comment = true;
        colors.green = "#00FF00";
      };
    };
  };
}
