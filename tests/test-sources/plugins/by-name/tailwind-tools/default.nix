{
  empty = {
    plugins.tailwind-tools.enable = true;

    test.warnings = expect: [
      (expect "count" 1)
      (expect "any" "Nixvim (plugins.tailwind-tools): This plugin has been deprecated.")
      (expect "any" "Consider disabling it or switching to an alternative.")
    ];
  };

  defaults = {
    plugins.tailwind-tools = {
      enable = true;

      settings = {
        server = {
          override = true;
          settings.__empty = { };
          on_attach.__raw = "function(client, bufnr) end";
        };
        document_color = {
          enabled = true;
          kind = "inline";
          inline_symbol = "󰝤 ";
          debounce = 200;
        };
        conceal = {
          enabled = false;
          min_length.__raw = "nil";
          symbol = "󱏿";
          highlight = {
            fg = "#38BDF8";
          };
        };
        cmp = {
          highlight = "foreground";
        };
        telescope = {
          utilities = {
            callback.__raw = "function(name, class) end";
          };
        };
        extension = {
          queries.__empty = { };
          patterns.__empty = { };
        };
      };
    };

    test.warnings = expect: [
      (expect "count" 1)
    ];
  };

  example = {
    plugins.tailwind-tools = {
      enable = true;

      settings = {
        document_color = {
          conceal = {
            enabled = true;
            symbol = "…";
          };
          document_color.kind = "background";
        };
      };
    };

    test.warnings = expect: [
      (expect "count" 1)
    ];
  };
}
