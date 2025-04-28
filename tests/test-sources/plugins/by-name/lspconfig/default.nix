{
  empty = {
    plugins.lspconfig.enable = true;
  };

  # TODO: test integration with `vim.lsp.enable`, etc
  # TODO: test some examples of enabling/configuring specific LSP servers

  plugins-lsp-warning = {
    plugins.lsp.enable = true;
    plugins.lspconfig.enable = true;

    test.warnings = expect: [
      (expect "count" 1)
      (expect "any" ''
        Nixvim (plugins.lspconfig): Both `plugins.lspconfig.enable' and `plugins.lsp.enable' configure the same plugin (nvim-lspconfig).
      '')
      (expect "any" "`plugins.lspconfig.enable' defined in `/nix/store/")
      (expect "any" "`plugins.lsp.enable' defined in `/nix/store/")
    ];

    test.buildNixvim = false;
  };
}
