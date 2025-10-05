{
  empty = {
    # TODO: 2025-10-03
    # Transient dependency `vmr` has a build failure
    # https://github.com/NixOS/nixpkgs/issues/431811
    dependencies.roslyn_ls.enable = false;
    plugins.roslyn.enable = true;
    plugins.rzls.enable = true;
  };

  defaults = {
    # TODO: 2025-10-03
    # Transient dependency `vmr` has a build failure
    # https://github.com/NixOS/nixpkgs/issues/431811
    dependencies.roslyn_ls.enable = false;
    plugins.roslyn.enable = true;
    plugins.rzls = {
      enable = true;
      settings = {
        on_attach.__raw = ''
          function()
              return nil
          end
        '';
        capabilities.__raw = ''vim.lsp.protocol.make_client_capabilities()'';
      };
    };
  };
}
