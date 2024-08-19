{
  example = {
    plugins.lsp = {
      enable = true;

      servers.jsonls = {
        # TODO: re-enable when pkg is fixed and available
        # https://github.com/NixOS/nixpkgs/pull/335559
        # enable = true;

        settings = {
          format = {
            enable = true;
          };
          validate = {
            enable = true;
          };
        };
      };
    };
  };
}
