{
  empty = {
    plugins = {
      lsp = {
        enable = true;
        # ltex-ls is no longer packaged in nixpkgs
        servers.ltex.package = null;
      };
      ltex-extra.enable = true;
    };
  };
}
