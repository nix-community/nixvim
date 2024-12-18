#########
# mkLsp #
#########
#
# Helper function that returns the Nix module `plugins.lsp.servers.<name>`.
#
{
  name,
  description ? "Enable ${name}.",
  serverName ? name,
  package ? null,
  url ? null,
  cmd ? (cfg: null),
  settings ? (cfg: cfg),
  settingsOptions ? { },
  extraConfig ? cfg: { },
  extraOptions ? { },
  ...
}@args:
# returns a module
{
  pkgs,
  config,
  options,
  helpers,
  lib,
  ...
}:
with lib;
let
  cfg = config.plugins.lsp.servers.${name};
  opts = options.plugins.lsp.servers.${name};

  enabled = config.plugins.lsp.enable && cfg.enable;
in
{
  meta.nixvimInfo = {
    # TODO: description
    url = args.url or opts.package.default.meta.homepage or null;
    path = [
      "plugins"
      "lsp"
      "servers"
      name
    ];
  };

  options = {
    plugins.lsp.servers.${name} = {
      enable = mkEnableOption description;

      package =
        if lib.isOption package then
          package
        else if args ? package then
          lib.mkPackageOption pkgs name {
            nullable = true;
            default = package;
          }
        else
          # If we're not provided a package, we should provide a no-default option
          lib.mkOption {
            type = types.nullOr types.package;
            description = ''
              The package to use for ${name}. Has no default, but can be set to null.
            '';
          };

      cmd = mkOption {
        type = with types; nullOr (listOf str);
        default =
          # TODO: do we really only want the default `cmd` when `package` is non-null?
          if !(opts.package.isDefined or false) then
            null
          else if cfg.package == null then
            null
          else if builtins.isFunction cmd then
            cmd cfg
          else
            cmd;
        description = ''
          A list where each entry corresponds to the blankspace delimited part of the command that
          launches the server.

          The first entry is the binary used to run the language server.
          Additional entries are passed as arguments.
        '';
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

      onAttach = helpers.mkCompositeOption "Server specific on_attach behavior." {
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

      settings = helpers.mkSettingsOption {
        description = "The settings for this LSP.";
        options = settingsOptions;
      };

      extraOptions = mkOption {
        default = { };
        type = types.attrsOf types.anything;
        description = "Extra options for the ${name} language server.";
      };
    } // extraOptions;
  };

  config = mkIf enabled {
    extraPackages = [ cfg.package ];

    plugins.lsp.enabledServers = [
      {
        name = serverName;
        extraOptions = {
          inherit (cfg) cmd filetypes autostart;
          root_dir = cfg.rootDir;
          on_attach = helpers.ifNonNull' cfg.onAttach (
            helpers.mkRaw ''
              function(client, bufnr)
                ${optionalString (!cfg.onAttach.override) config.plugins.lsp.onAttach}
                ${cfg.onAttach.function}
              end
            ''
          );
          settings = lib.nixvim.plugins.utils.applyExtraConfig {
            extraConfig = settings;
            cfg = cfg.settings;
            opts = opts.settings;
            enabled = true;
          };
        } // cfg.extraOptions;
      }
    ];
  };

  imports =
    let
      basePath = [
        "plugins"
        "lsp"
        "servers"
      ];
      basePluginPath = basePath ++ [ name ];
      basePluginPathString = concatStringsSep "." basePluginPath;
    in
    [
      (mkRemovedOptionModule (
        basePluginPath ++ [ "extraSettings" ]
      ) "You can use `${basePluginPathString}.extraOptions.settings` instead.")
    ]
    ++ lib.optional (args ? extraConfig) (
      lib.nixvim.plugins.utils.applyExtraConfig {
        inherit
          extraConfig
          cfg
          opts
          enabled
          ;
      }
    )
    # Add an alias (with warning) for the lspconfig server name, if different to `name`.
    # Note: users may use lspconfig's docs to guess the `plugins.lsp.servers.*` name
    ++ (optional (name != serverName) (
      mkRenamedOptionModule (basePath ++ [ serverName ]) basePluginPath
    ));
}
