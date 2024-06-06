{
  empty = {
    plugins = {
      lsp = {
        enable = true;

        servers = {
          jsonls.enable = true;
          yamlls.enable = true;
        };
      };

      schemastore.enable = true;
    };
  };

  example = {
    plugins = {
      lsp = {
        enable = true;

        servers = {
          jsonls.enable = true;
          yamlls.enable = true;
        };
      };

      schemastore = {
        enable = true;

        json = {
          enable = true;
          settings = {
            replace."package.json" = {
              description = "package.json overridden";
              fileMatch = [ "package.json" ];
              name = "package.json";
              url = "https://example.com/package.json";
            };
            extra = [
              {
                description = "My custom JSON schema";
                fileMatch = "foo.json";
                name = "foo.json";
                url = "https://example.com/schema/foo.json";
              }
              {
                description = "My other custom JSON schema";
                fileMatch = [
                  "bar.json"
                  ".baar.json"
                ];
                name = "bar.json";
                url = "https://example.com/schema/bar.json";
              }
            ];
          };
        };
        yaml = {
          enable = true;
          settings = { };
        };
      };
    };
  };

  withJson = {
    plugins = {
      lsp = {
        enable = true;
        servers.jsonls.enable = true;
      };

      schemastore = {
        enable = true;

        json = {
          enable = true;
          settings = { };
        };
        yaml.enable = false;
      };
    };
  };

  withYaml = {
    plugins = {
      lsp = {
        enable = true;
        servers.yamlls.enable = true;
      };

      schemastore = {
        enable = true;

        json.enable = false;
        yaml = {
          enable = true;
          settings = { };
        };
      };
    };
  };
}
