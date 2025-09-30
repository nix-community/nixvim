{
  empty = {
    # TODO 2025-10-01
    # Calls `require("lspconfig")` which is deprecated, producing a warning
    test.runNvim = false;

    plugins.idris2.enable = true;
  };
}
