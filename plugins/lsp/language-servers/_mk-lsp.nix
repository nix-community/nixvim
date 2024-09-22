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
  package ? name,
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
  opt = options.plugins.lsp.servers.${name};
  # `package.default` will throw "not found in pkgs" if the nixpkgs channel is mismatched
  pkg = (builtins.tryEval opt.package.default).value;
  url = args.url or pkg.meta.homepage or null;
in
{
  meta.nixvimInfo = {
    # TODO: description
    inherit url;
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
        else
          lib.mkPackageOption pkgs name {
            nullable = true;
            default = package;
          };

      cmd = mkOption {
        type = with types; nullOr (listOf str);
        default = if (cfg.package or null) != null then cmd cfg else null;
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

  config = mkIf cfg.enable {
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
          settings = settings cfg.settings;
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
      (extraConfig cfg)
    ]
    # Add an alias (with warning) for the lspconfig server name, if different to `name`.
    # Note: users may use lspconfig's docs to guess the `plugins.lsp.servers.*` name
    ++ (optional (name != serverName) (
      mkRenamedOptionModule (basePath ++ [ serverName ]) basePluginPath
    ));
}
