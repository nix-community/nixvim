{
  empty = {
    plugins.better-escape.enable = true;
  };

  example = {
    plugins.better-escape = {
      enable = true;

      mapping = ["jj" "jk"];
      timeout = 150;
      clearEmptyLines = false;
      keys = "<ESC>";
    };
  };
}
