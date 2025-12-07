{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mkIf
    mkDefault
    ;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "schemastore";
  package = "SchemaStore-nvim";
  description = "A Neovim plugin that provides the SchemaStore catalog for use with jsonls and yamlls.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions =
    let
      schemaEntry = types.submodule {
        freeformType = with types; attrsOf anything;
        options = {
          name = mkOption {
            type = with lib.types; maybeRaw str;
            description = "The name of the schema.";
          };

          description = lib.nixvim.mkNullOrStr "A description for this schema.";

          fileMatch =
            lib.nixvim.mkNullOrOption (with lib.types; maybeRaw (either str (listOf (maybeRaw str))))
              ''
                Which filename to match against for this schema.
              '';

          url = mkOption {
            type = with lib.types; maybeRaw str;
            description = "The URL of this schema.";
          };
        };
      };

      schemaOpts = {
        select = lib.nixvim.defaultNullOpts.mkListOf types.str [ ] ''
          A list of strings representing the names of schemas to select.
          If this option is not present, all schemas are returned.
          If it is present, only the selected schemas are returned.
          `select` and `ignore` are mutually exclusive.

          See the [schema catalog](https://github.com/SchemaStore/schemastore/blob/master/src/api/json/catalog.json).
        '';

        ignore = lib.nixvim.defaultNullOpts.mkListOf types.str [ ] ''
          A list of strings representing the names of schemas to ignore.
          `select` and `ignore` are mutually exclusive.

          See the [schema catalog](https://github.com/SchemaStore/schemastore/blob/master/src/api/json/catalog.json).
        '';

        replace = lib.nixvim.defaultNullOpts.mkAttrsOf schemaEntry { } ''
          An attrs of elements representing schemas to replace with a custom schema.

          The string key is the name of the schema to replace, the table value is the schema definition.
          If a schema with the given name isn't found, the custom schema will not be returned.
        '';

        extra = lib.nixvim.defaultNullOpts.mkListOf schemaEntry [ ] ''
          Additional schemas to include.
        '';
      };
    in
    {
      json = {
        enable = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = "Whether to enable the json schemas in jsonls.";
        };

        settings = lib.nixvim.mkSettingsOption {
          options = schemaOpts;
          description = "Options supplied to the `require('schemastore').json.schemas` function.";
          example = {
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
      };

      yaml = {
        enable = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = "Whether to enable the yaml schemas in yamlls.";
        };

        settings = lib.nixvim.mkSettingsOption {
          options = schemaOpts;
          description = "Options supplied to the `require('schemastore').yaml.schemas` function.";
        };
      };
    };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.schemastore" [
      {
        when = !(cfg.json.enable || cfg.yaml.enable);
        message = "You have enabled the plugin, but neither `json` or `yaml` schemas are enabled.";
      }
      {
        when =
          cfg.json.enable && !(config.plugins.lsp.servers.jsonls.enable || config.lsp.servers.jsonls.enable);
        message = ''
          You have enabled `json` schemas, but neither `plugins.lsp.servers.jsonls` nor `lsp.servers.jsonls` is enabled.
        '';
      }
      {
        when =
          cfg.yaml.enable && !(config.plugins.lsp.servers.yamlls.enable || config.lsp.servers.yamlls.enable);
        message = ''
          You have enabled `yaml` schemas, but neither `plugins.lsp.servers.yamlls` nor `lsp.servers.yamlls` is enabled.
        '';
      }
    ];

    # TODO: Remove once `plugins.lsp` is defunct.
    plugins.lsp.servers = {
      jsonls.settings = mkIf cfg.json.enable {
        schemas.__raw = ''
          require('schemastore').json.schemas(${lib.nixvim.toLuaObject cfg.json.settings})
        '';

        # The plugin recommends to enable this option in its README.
        # Learn more: https://github.com/b0o/SchemaStore.nvim/issues/8
        validate.enable = mkDefault true;
      };

      yamlls.settings = mkIf cfg.yaml.enable {
        schemaStore = {
          # From the README: "You must disable built-in schemaStore support if you want to use
          # this plugin and its advanced options like `ignore`."
          enable = mkDefault false;

          # From the README: "Avoid TypeError: Cannot read properties of undefined (reading 'length')"
          url = mkDefault "";
        };

        schemas.__raw = ''
          require('schemastore').yaml.schemas(${lib.nixvim.toLuaObject cfg.yaml.settings})
        '';
      };
    };

    lsp.servers = {
      jsonls.config.settings.json = mkIf cfg.json.enable {
        schemas.__raw = ''
          require('schemastore').json.schemas(${lib.nixvim.toLuaObject cfg.json.settings})
        '';

        # The plugin recommends to enable this option in its README.
        # Learn more: https://github.com/b0o/SchemaStore.nvim/issues/8
        validate.enable = mkDefault true;
      };

      yamlls.config.settings.yaml = mkIf cfg.yaml.enable {
        schemaStore = {
          # From the README: "You must disable built-in schemaStore support if you want to use
          # this plugin and its advanced options like `ignore`."
          enable = mkDefault false;

          # From the README: "Avoid TypeError: Cannot read properties of undefined (reading 'length')"
          url = mkDefault "";
        };

        schemas.__raw = ''
          require('schemastore').yaml.schemas(${lib.nixvim.toLuaObject cfg.yaml.settings})
        '';
      };
    };
  };
}
