{
  empty = {
    plugins.better-escape.enable = true;
  };

  example = {
    plugins.better-escape = {
      enable = true;
      mappings = ["jj" "jk"];
      timeout = 150;
      clearEmptyLines = false;
      keys = "<ESC>";
    };
  };
}
