{
  empty = {
    plugins.tailwind-tools.enable = true;
  };

  defaults = {
    plugins.tailwind-tools = {
      enable = true;

      settings = {
        server = {
          override = true;
          settings = { };
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
          min_length = null;
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
          queries = [ ];
          patterns = { };
        };
      };
    };
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
  };
}
