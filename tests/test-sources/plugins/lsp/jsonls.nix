{
  example = {
    plugins.lsp = {
      enable = true;

      servers.jsonls = {
        enable = true;

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
