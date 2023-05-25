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
    options,
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
            type = types.package;
          };
        }
        else {};
    in {
      options = {
        plugins.lsp.servers.${name} =
          {
            enable = mkEnableOption description;

            installLanguageServer = mkOption {
              type = types.bool;
              default = true;
              description = "Whether nixvim should take care of installing the language server.";
            };

            cmd = mkOption {
              type = with types; nullOr (listOf str);
              default =
                if cfg.installLanguageServer
                then cmd cfg
                else null;
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

            rootDir = helpers.mkNullOrOption types.str ''
              A function (or function handle) which returns the root of the project used to
              determine if lspconfig should launch a new language server, or attach a previously
              launched server when you open a new buffer matching the filetype of the server.
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
                  type = types.lines;
                  description = ''
                    Body of the on_attach function.
                    The argument `client` and `bufnr` is provided.
                  '';
                };
              };

            settings = settingsOptions;

            extraSettings = mkOption {
              type = types.attrs;
              description = ''
                Extra settings for the ${name} language server.
              '';
            };

            extraOptions = mkOption {
              default = {};
              type = types.attrs;
              description = "Extra options for the ${name} language server.";
            };
          }
          // packageOption;
      };

      config = let
        extraSettingsOption = options.plugins.lsp.servers.${name}.extraSettings;
        extraSettingsAreDefined = extraSettingsOption.isDefined;
      in
        mkIf cfg.enable
        {
          extraPackages =
            (
              optional
              (cfg.installLanguageServer && (package != null))
              cfg.package
            )
            ++ (mapAttrsToList (name: _: cfg."${name}Package") extraPackages);

          plugins.lsp.enabledServers = [
            {
              name = serverName;
              extraOptions =
                {
                  inherit (cfg) cmd filetypes autostart;
                  root_dir =
                    helpers.ifNonNull' cfg.rootDir
                    (helpers.mkRaw cfg.rootDir);
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
                  settings =
                    (settings cfg.settings)
                    // (
                      if extraSettingsAreDefined
                      then cfg.extraSettings
                      else {}
                    );
                }
                // cfg.extraOptions;
            }
          ];

          warnings =
            optional extraSettingsAreDefined
            (
              let
                optionPrefix = "plugins.lsp.servers.${name}";
              in "The `${optionPrefix}.extraSettings` option is deprecated in favor of `${optionPrefix}.extraOptions.settings`."
            );
        };
    };
}
