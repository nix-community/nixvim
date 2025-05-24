{ lib, pkgs, ... }:
{
  empty = {
    plugins = {
      lsp = {
        enable = true;
        servers.yamlls.enable = true;
      };

      yaml-companion.enable = true;
    };
  };

  defaults = {
    plugins = {
      lsp = {
        enable = true;
        servers.yamlls.enable = true;
      };

      yaml-companion = {
        enable = true;

        settings = {
          builtin_matchers = {
            kubernetes.enabled = true;
            cloud_init.enabled = true;
          };
          schemas = [ ];
          lspconfig = {
            flags = {
              debounce_text_changes = 150;
            };
            settings = {
              redhat.telemetry.enabled = false;
              yaml = {
                validate = true;
                format.enable = true;
                hover = true;
                schemaStore = {
                  enable = true;
                  url = "https://www.schemastore.org/api/json/catalog.json";
                };
                schemaDownload.enable = true;
                schemas = [ ];
                trace.server = "debug";
              };
            };
          };
        };
      };
    };
  };

  example = {
    extraPlugins = [ pkgs.vimPlugins.SchemaStore-nvim ];
    plugins = {
      lsp = {
        enable = true;
        servers.yamlls.enable = true;
      };

      yaml-companion = {
        enable = true;

        settings = {
          schemas = [
            {
              name = "Argo CD Application";
              uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json";
            }
            {
              name = "SealedSecret";
              uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json";
            }
          ];
          lspconfig = {
            settings = {
              yaml = {
                format.enable = false;
                schemaStore = {
                  enable = false;
                  url = "";
                };
                schemas = lib.nixvim.mkRaw "require('schemastore').yaml.schemas()";
              };
            };
          };
        };
      };
    };
  };
}
