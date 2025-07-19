{
  empty = {
    plugins.lspkind = {
      enable = true;
      cmp.enable = false;
    };
  };

  example = {
    plugins = {
      lsp = {
        enable = true;
        servers.clangd.enable = true;
      };
      cmp.enable = true;
      lspkind.enable = true;
    };
  };

  defaults = {
    plugins.lspkind = {
      enable = true;
      settings = {
        mode = "symbol_text";
        preset = "codicons";
        symbol_map = null;
      };
      cmp = {
        enable = false;
        after = null;
      };
    };
  };
}
