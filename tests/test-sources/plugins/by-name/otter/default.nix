{
  empty = {
    plugins = {
      otter.enable = true;
      # Avoid the warning
      treesitter = {
        enable = true;
        highlight.enable = true;
      };
    };
  };
  emptyOldApi = {
    plugins = {
      otter.enable = true;
      # Avoid the warning
      treesitter = {
        enable = true;
        settings.highlight.enable = true;
      };
    };
  };

  defaults = {
    plugins = {
      # Avoid the warning
      treesitter = {
        enable = true;
        highlight.enable = true;
      };

      otter = {
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
  };

  warning-no-highlight = {
    test.runNvim = false;
    test.warnings = expect: [
      (expect "count" 1)
      (expect "any" "You have enabled otter, but treesitter syntax highlighting is not enabled.")
      (expect "any" "Make sure `plugins.treesitter.highlight.enable` and `plugins.treesitter.enable` are enabled.")
    ];
    plugins = {
      otter.enable = true;
      treesitter.enable = true;
    };
  };

  warning-no-treesitter = {
    test.runNvim = false;
    test.warnings = expect: [
      (expect "count" 1)
      (expect "any" "You have enabled otter, but treesitter syntax highlighting is not enabled.")
      (expect "any" "Make sure `plugins.treesitter.highlight.enable` and `plugins.treesitter.enable` are enabled.")
    ];
    plugins = {
      otter.enable = true;
      treesitter.highlight.enable = true;
    };
  };
}
