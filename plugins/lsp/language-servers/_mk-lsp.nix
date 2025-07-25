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
  cmd ? null,
  cmdText ? throw "cmdText is required when cmd is a function",
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
  lib,
  ...
}:
let
  cfg = config.plugins.lsp.servers.${name};
  opts = options.plugins.lsp.servers.${name};

  enabled = config.plugins.lsp.enable && cfg.enable;

  inherit (lib) mkOption types;
in
{
  meta.nixvimInfo = {
    # TODO: description
    # The package default can throw when the server is unpackaged, so use tryEval
    url = args.url or (builtins.tryEval opts.package.default).value.meta.homepage or null;
    path = [
      "plugins"
      "lsp"
      "servers"
      name
    ];
  };

  options = {
    plugins.lsp.servers.${name} = {
      enable = lib.mkEnableOption description;

      package =
        lib.nixvim.mkMaybeUnpackagedOption "plugins.lsp.servers.${name}.package" pkgs name
          package;

      packageFallback = mkOption {
        type = types.bool;
        default = false;
        description = ''
          When enabled, the language server package will be added to the end of the `PATH` _(suffix)_ instead of the beginning _(prefix)_.

          This can be useful if you want local versions of the language server (e.g. from a devshell) to override the nixvim version.
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
        defaultText = lib.literalMD ''
          null when `package` is null, otherwise ${
            if args ? cmdText || builtins.isFunction cmd then
              let
                literal = lib.options.renderOptionValue cmdText;
                inherit (literal) text;
              in
              if literal._type == "literalMD" then
                text
              else if lib.hasInfix "\n" text || lib.hasInfix "``" text then
                "\n\n```\n${text}\n```"
              else
                "`` ${text} ``"
            else if cmd == null then
              "null"
            else
              "`[ ${lib.concatMapStringsSep " " builtins.toJSON cmd} ]`"
          }
        '';
        description = ''
          A list where each entry corresponds to the blankspace delimited part of the command that
          launches the server.

          The first entry is the binary used to run the language server.
          Additional entries are passed as arguments.
        '';
      };

      filetypes = lib.nixvim.mkNullOrOption (types.listOf types.str) ''
        Set of filetypes for which to attempt to resolve {root_dir}.
        May be empty, or server may specify a default value.
      '';

      autostart = lib.nixvim.defaultNullOpts.mkBool true ''
        Controls if the `FileType` autocommand that launches a language server is created.
        If `false`, allows for deferring language servers until manually launched with
        `:LspStart` (|lspconfig-commands|).
      '';

      rootMarkers = lib.nixvim.defaultNullOpts.mkListOf types.str null ''
        A list of files that mark the root of the project/workspace.

        Vim's LSP will try to share the same language server instance for all
        buffers matching `filetypes` within the same project.

        A new server instance is only spawned when opening a buffer with a
        different project root.

        See `:h lsp-config` and `:h vim.fs.root()`.
      '';

      onAttach = lib.nixvim.mkCompositeOption "Server specific on_attach behavior." {
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

      settings = lib.nixvim.mkSettingsOption {
        description = "The settings for this LSP.";
        options = settingsOptions;
      };

      extraOptions = mkOption {
        default = { };
        type = types.attrsOf types.anything;
        description = "Extra options for the ${name} language server.";
      };
    }
    // extraOptions;
  };

  config = lib.mkIf enabled {
    extraPackages = lib.optional (!cfg.packageFallback) cfg.package;
    extraPackagesAfter = lib.optional cfg.packageFallback cfg.package;

    plugins.lsp.enabledServers = [
      {
        name = serverName;
        extraOptions = {
          inherit (cfg) cmd filetypes autostart;
          root_markers = cfg.rootMarkers;
          on_attach = lib.nixvim.ifNonNull' cfg.onAttach (
            lib.nixvim.mkRaw ''
              function(client, bufnr)
                ${lib.optionalString (!cfg.onAttach.override) config.plugins.lsp.onAttach}
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
        }
        // cfg.extraOptions;
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
      basePluginPathString = builtins.concatStringsSep "." basePluginPath;
    in
    [
      (lib.mkRemovedOptionModule (
        basePluginPath ++ [ "extraSettings" ]
      ) "You can use `${basePluginPathString}.extraOptions.settings` instead.")
      (lib.mkRemovedOptionModule (basePluginPath ++ [ "rootDir" ]) ''

        nvim-lspconfig has switched from its own `root_dir` implementation to using neovim's built-in LSP API.

        In most cases you can use `${opts.rootMarkers}` instead. It should be a list of files that mark the root of the project.
        In more complex cases you can still use `${opts.extraOptions}.root_dir`.
      '')
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
    ++ (lib.optional (name != serverName) (
      lib.mkRenamedOptionModule (basePath ++ [ serverName ]) basePluginPath
    ));
}
