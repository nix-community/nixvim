{
  example = {
    plugins.lsp = {
      enable = true;

      servers.yamlls = {
        enable = true;

        settings = {
          hover = true;
          completion = true;
          validate = true;
          schemaStore = {
            enable = true;
            url = "https://www.schemastore.org/api/json/catalog.json";
          };
        };
      };
    };
  };
}
