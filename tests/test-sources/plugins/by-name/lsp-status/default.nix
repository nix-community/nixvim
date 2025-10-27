{
  empty = {
    plugins = {
      lsp.enable = true;
      lsp-status.enable = true;
    };
  };

  defaults = {
    plugins = {
      lsp.enable = true;
      lsp-status = {
        enable = true;

        settings = {
          kind_labels.__empty = { };
          select_symbol = "";
          current_function = true;
          show_filename = true;
          indicator_ok = "OK";
          indicator_errors = "E";
          indicator_warnings = "W";
          indicator_info = "i";
          indicator_hint = "?";
          indicator_separator = " ";
          component_separator = " ";
          diagnostics = true;
        };
      };
    };
  };
}
