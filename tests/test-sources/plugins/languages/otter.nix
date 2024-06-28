{
  empty = {
    plugins.otter.enable = true;
  };

  defaults = {
    plugins.otter = {
      enable = true;

      settings = {
        lsp = {
          hover = {
            border = [
              "╭"
              "─"
              "╮"
              "│"
              "╯"
              "─"
              "╰"
              "│"
            ];
          };
          diagnostic_update_events = [ "BufWritePost" ];
        };
        buffers = {
          set_filetype = false;
          write_to_disk = false;
        };
        strip_wrapping_quote_characters = [
          "'"
          "\""
          "\`"
        ];
        handle_leading_whitespace = false;
      };
    };
  };
}
