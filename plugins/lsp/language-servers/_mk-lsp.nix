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

      # alias to lsp.servers.${name}.package
      package =
        let
          getSubOptions = opt: opt.type.getSubOptions opt.loc;
          serverOpts = getSubOptions options.lsp.servers;
          opt = lib.pipe serverOpts [
            (lib.getAttr serverName)
            getSubOptions
            (lib.getAttr "package")
          ];
          pkg = config.lsp.servers.${serverName}.package;
          self = options.plugins.lsp.servers.${name}.package;
        in
        if serverOpts ? ${serverName} then
          lib.mkOption (
            {
              inherit (opt) type default description;
              apply =
                v:
                if enabled then
                  pkg
                else if self.isDefined then
                  v
                else
                  opt.default or v;
            }
            // lib.optionalAttrs (opt ? example) { inherit (opt) example; }
            // lib.optionalAttrs (opt ? defaultText) { inherit (opt) defaultText; }
          )
        else
          # If there's no explicit option, that means there isn't a known package, so the server uses freeformType
          lib.nixvim.mkUnpackagedOption options.plugins.lsp.servers.${name}.package name
          // {
            apply = v: if enabled then config.lsp.servers.${serverName}.packageFallback else v;
          };

      packageFallback = mkOption {
        type = types.bool;
        default = false;
        description = ''
          When enabled, the language server package will be added to the end of the `PATH` _(suffix)_ instead of the beginning _(prefix)_.

          This can be useful if you want local versions of the language server (e.g. from a devshell) to override the nixvim version.
        '';
        apply = v: if enabled then config.lsp.servers.${serverName}.packageFallback else v;
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
    # The server submodule is using `shorthandOnlyDefinesConfig`,
    # so define a "longhand" function module.
    lsp.servers.${serverName} = _: {
      # Top-secret internal option that only exists when the server is enabled via the old API.
      # The new API checks if this attr exists and uses it to wrap the server's lua cfg string.
      options.__configWrapper = lib.mkOption {
        type = lib.types.functionTo lib.types.str;
        description = ''
          This internal option exists to preserve the old `plugins.lsp` behaviour.

          > [!IMPORTANT]
          > This option should not be used by end-users!
          > It will be removed when `plugins.lsp` is dropped.
        '';
        readOnly = true;
        internal = true;
        visible = false;
      };

      # Propagate definitions to the new lsp module
      config = {
        enable = true;
        package = lib.mkIf (opts.package.highestPrio < 1500) (
          lib.modules.mkAliasAndWrapDefsWithPriority lib.id opts.package
        );
        packageFallback = lib.modules.mkAliasAndWrapDefsWithPriority lib.id opts.packageFallback;
        __configWrapper =
          luaConfig: "__wrapConfig(${lib.foldr lib.id luaConfig config.plugins.lsp.setupWrappers})";
        cfg = {
          autostart = lib.mkIf (cfg.autostart != null) cfg.autostart;
          cmd = lib.mkIf (cfg.cmd != null) cfg.cmd;
          filetypes = lib.mkIf (cfg.filetypes != null) cfg.filetypes;
          root_markers = lib.mkIf (cfg.rootMarkers != null) cfg.rootMarkers;
          on_attach = lib.mkIf (cfg.onAttach != null) (
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
      };
    };
  };

  imports =
    let
      basePath = [
        "plugins"
        "lsp"
        "servers"
      ];
      basePluginPath = basePath ++ [ name ];
    in
    [
      (lib.mkRemovedOptionModule (
        basePluginPath ++ [ "extraSettings" ]
      ) "You can use `${opts.extraOptions}.settings` instead.")
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
