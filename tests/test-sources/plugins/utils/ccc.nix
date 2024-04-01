{
  empty = {
    plugins.ccc.enable = true;
  };

  example = {
    plugins.ccc = {
      enable = true;
      default_color = "#FFFFFF";
      highlight_mode = "fg";
      lsp = true;
      highlighter = {
        auto_enable = true;
        lsp = true;
      };
    };
  };
}
