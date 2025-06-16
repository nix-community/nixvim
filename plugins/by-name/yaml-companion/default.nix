{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "yaml-companion";
  packPathName = "yaml-companion.nvim";
  package = "yaml-companion-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
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
          schemas = lib.nixvim.nestedLiteralLua "require('schemastore').yaml.schemas()";
        };
      };
    };
  };

  callSetup = false;
  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.yaml-companion" [
      {
        when = !config.plugins.lsp.enable;
        message = "This plugin requires the `plugins.lsp.servers.yamlls` module to be enabled.";
      }
    ];

    plugins = {
      lsp.servers.yamlls.extraOptions = lib.nixvim.mkRaw "require('yaml-companion').setup(${lib.nixvim.toLuaObject cfg.settings})";

      telescope.enabledExtensions = [ "yaml_schema" ];
    };
  };
}
