{pkgs, ...}: {
  mkLsp = {
    name,
    description ? "Enable ${name}.",
    serverName ? name,
    package ? pkgs.${name},
    cmd ? (cfg: null),
    settings ? (cfg: cfg),
    settingsOptions ? {},
    ...
  }:
  # returns a module
  {
    pkgs,
    config,
    helpers,
    lib,
    ...
  }:
    with lib; let
      cfg = config.plugins.lsp.servers.${name};
    in {
      options = {
        plugins.lsp.servers.${name} = {
          enable = mkEnableOption description;

          package = mkOption {
            default = package;
            type = types.nullOr types.package;
            description = "Which package to use for ${name}.";
          };

          cmd = mkOption {
            type = with types; nullOr (listOf str);
            default =
              if (cfg.package or null) != null
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

          rootDir = helpers.defaultNullOpts.mkLuaFn "nil" ''
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

          extraOptions = mkOption {
            default = {};
            type = types.attrsOf types.anything;
            description = "Extra options for the ${name} language server.";
          };
        };
      };

      config =
        mkIf cfg.enable
        {
          extraPackages = [cfg.package];

          plugins.lsp.enabledServers = [
            {
              name = serverName;
              extraOptions =
                {
                  inherit (cfg) cmd filetypes autostart;
                  root_dir = cfg.rootDir;
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
                  settings = settings cfg.settings;
                }
                // cfg.extraOptions;
            }
          ];
        };
      imports = let
        basePluginPath = ["plugins" "lsp" "servers" name];
        basePluginPathString = concatStringsSep "." basePluginPath;
      in [
        (
          mkRemovedOptionModule
          (basePluginPath ++ ["extraSettings"])
          "You can use `${basePluginPathString}.extraOptions.settings` instead."
        )
      ];
    };
}
