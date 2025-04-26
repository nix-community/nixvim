{
  empty = {
    plugins.lsp-lines.enable = true;
  };

  example = {
    plugins.lsp-lines.enable = true;

    diagnostic.config.virtual_lines = {
      only_current_line = true;
      highlight_whole_line = false;
    };
  };
}
