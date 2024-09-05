{
  empty = {
    plugins.lspkind.enable = true;
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
      mode = "symbol_text";
      preset = "codicons";
      symbolMap = null;
      cmp = {
        enable = true;
        maxWidth = 50;
        ellipsisChar = "...";
        menu = null;
        after = null;
      };
    };
  };
}
