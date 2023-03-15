{
  # Empty configuration
  empty = {
    plugins.lspkind.enable = true;
  };

  # All the upstream default options of lspkind
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
