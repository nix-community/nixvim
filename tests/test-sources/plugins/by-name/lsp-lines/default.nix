{
  empty = {
    plugins.lsp-lines.enable = true;
  };

  example = {
    plugins.lsp-lines.enable = true;

    diagnostic.settings.virtual_lines = {
      only_current_line = true;
      highlight_whole_line = false;
    };
  };
}
