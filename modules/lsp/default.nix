{
  lib,
  config,
  options,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) toLuaObject;

  cfg = config.lsp;

  # Import `server.nix` and apply args
  # For convenience, we set a default here for args.pkgs
  mkServerModule = args: lib.modules.importApply ./server.nix ({ inherit pkgs; } // args);

  # Create a submodule type from `server.nix`
  # Used as the type for both the freeform `lsp.servers.<name>`
  # and the explicitly declared `lsp.servers.*` options
  mkServerType = args: types.submodule (mkServerModule args);

  # Create a server option
  # Used below for the `lsp.servers.*` options
  mkServerOption =
    name: args:
    let
      homepage = lib.pipe options.lsp.servers [
        # Get suboptions of `lsp.servers`
        (opt: opt.type.getSubOptions opt.loc)
        # Get suboptions of `lsp.servers.<name>`
        (opts: opts.${name}.type.getSubOptions opts.${name}.loc)
        # Get package option's homepage
        (opts: opts.package.default.meta.homepage or null)
      ];

      # If there's a known homepage for this language server,
      # we'll link to it in the option description
      nameLink = if homepage == null then name else "[${name}](${homepage})";
    in
    lib.mkOption {
      type = mkServerType args;
      description = ''
        The ${nameLink} language server.
      '';
      default = { };
    };

  # Combine `packages` and `customCmd` sets from `lsp-packages.nix`
  # We use this set to generate the package-option defaults
  serverPackages =
    let
      inherit (import ../../plugins/lsp/lsp-packages.nix)
        packages
        customCmd
        ;
    in
    builtins.mapAttrs (name: v: {
      inherit name;
      package = v.package or v;
    }) (packages // customCmd);
in
{
  options.lsp = {
    luaConfig = lib.mkOption {
      type = lib.types.pluginLuaConfig;
      default = { };
      description = ''
        Lua code configuring LSP.
      '';
    };

    inlayHints = {
      enable = lib.mkEnableOption "inlay hints globally";
    };

    servers = lib.mkOption {
      type = types.submodule {
        freeformType = types.attrsOf (mkServerType { });
        options = builtins.mapAttrs mkServerOption serverPackages;
      };

      description = ''
        LSP servers to enable and/or configure.

        This option is implemented using neovim's `vim.lsp` lua API.

        You may also want to use [nvim-lspconfig] to install _default configs_ for many language servers.
        This can be installed using [`${options.plugins.lspconfig.enable}`][`plugins.lspconfig`].

        [nvim-lspconfig]: ${options.plugins.lspconfig.package.default.meta.homepage}
        [`plugins.lspconfig`]: ../../plugins/lspconfig/index.md
      '';
      default = { };
      example = {
        "*" = {
          enable = true;
          settings = {
            root_markers = [ ".git" ];
            capabilities.textDocument.semanticTokens = {
              multilineTokenSupport = true;
            };
          };
        };
        luals.enable = true;
        clangd = {
          enable = true;
          settings = {
            cmd = [
              "clangd"
              "--background-index"
            ];
            root_markers = [
              "compile_commands.json"
              "compile_flags.txt"
            ];
            filetypes = [
              "c"
              "cpp"
            ];
          };
        };
      };
    };
  };

  config =
    let
      enabledServers = lib.pipe cfg.servers [
        builtins.attrValues
        (builtins.filter (server: server.enable))
      ];

      # Collect per-server warnings
      serverWarnings = lib.pipe cfg.servers [
        builtins.attrValues
        (builtins.catAttrs "warnings")
        builtins.concatLists
      ];
    in
    {
      extraPackages = builtins.catAttrs "package" enabledServers;

      lsp.luaConfig.content =
        let
          mkServerConfig =
            server:
            let
              luaName = toLuaObject server.name;
              luaSettings = toLuaObject server.settings;
            in
            ''
              vim.lsp.config(${luaName}, ${luaSettings})
            ''
            + lib.optionalString server.activate ''
              vim.lsp.enable(${luaName})
            '';
        in
        lib.mkMerge (
          lib.optional cfg.inlayHints.enable "vim.lsp.inlay_hint.enable(true)"
          ++ builtins.map mkServerConfig enabledServers
        );

      extraConfigLua = lib.mkIf (cfg.luaConfig.content != "") ''
        -- LSP {{{
        do
          ${cfg.luaConfig.content}
        end
        -- }}}
      '';

      # Propagate per-server warnings
      warnings = lib.mkIf (serverWarnings != [ ]) serverWarnings;
    };
}
