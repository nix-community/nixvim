{
  pkgs,
  config,
  lib,
  ...
}: {
  mkLsp = {
    name,
    description ? "Enable ${name}.",
    serverName ? name,
    package ? pkgs.${name},
    extraPackages ? {},
    cmd ? (cfg: null),
    settings ? (cfg: cfg),
    settingsOptions ? {},
    ...
  }:
  # returns a module
  {
    pkgs,
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.plugins.lsp.servers.${name};
      helpers = import ../helpers.nix {inherit lib;};

      packageOption =
        if package != null
        then {
          package = mkOption {
            default = package;
            type = types.nullOr types.package;
          };
        }
        else {};
    in {
      options = {
        plugins.lsp.servers.${name} =
          {
            enable = mkEnableOption description;

            cmd = mkOption {
              type = with types; nullOr (listOf str);
              default = cmd cfg;
            };

            filetypes = helpers.mkNullOrOption (types.listOf types.str) ''
              Set of filetypes for which to attempt to resolve {root_dir}.
              May be empty, or server may specify a default value.
            '';

            autostart = helpers.defaultNullOpts.mkBool true ''
              Controls if the `FileType` autocommand that launches a language server is created.
              If `false`, allows for deferring language servers until manually launched with
              `:LspStart` (|lspconfig-commands|).
            '';

            onAttach =
              helpers.mkCompositeOption "Server specific on_attach behavior."
              {
                override = mkOption {
                  type = types.bool;
                  default = false;
                  description = "Override the global `plugins.lsp.onAttach` function.";
                };

                function = mkOption {
                  type = types.str;
                  description = ''
                    Body of the on_attach function.
                    The argument `client` and `bufnr` is provided.
                  '';
                };
              };

            settings = settingsOptions;

            extraSettings = mkOption {
              default = {};
              type = types.attrs;
              description = ''
                Extra settings for the ${name} language server.
              '';
            };
          }
          // packageOption;
      };

      config =
        mkIf cfg.enable
        {
          extraPackages =
            (optional (package != null) cfg.package)
            ++ (mapAttrsToList (name: _: cfg."${name}Package") extraPackages);

          plugins.lsp.enabledServers = [
            {
              name = serverName;
              extraOptions = {
                inherit (cfg) cmd filetypes autostart;
                on_attach =
                  helpers.ifNonNull' cfg.onAttach
                  (
                    helpers.mkRaw ''
                      function(client, bufnr)
                        ${optionalString (!cfg.onAttach.override) config.plugins.lsp.onAttach}
                        ${cfg.onAttach.function}
                      end
                    ''
                  );
                settings = (settings cfg.settings) // cfg.extraSettings;
              };
            }
          ];
        };
    };
}
