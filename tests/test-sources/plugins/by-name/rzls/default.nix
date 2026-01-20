{
  empty = {
    plugins.roslyn.enable = true;
    plugins.rzls.enable = true;
  };

  defaults = {
    plugins.roslyn.enable = true;
    plugins.rzls = {
      enable = true;
      settings = {
        on_attach.__raw = ''
          function()
              return nil
          end
        '';
        capabilities.__raw = "vim.lsp.protocol.make_client_capabilities()";
      };
    };
  };
}
