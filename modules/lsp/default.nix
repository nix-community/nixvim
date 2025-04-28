{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) toLuaObject;

  cfg = config.lsp;
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
      type = types.attrsOf (types.submodule ./server.nix);
      description = ''
        LSP servers to enable and/or configure.

        This option is implemented using neovim's `vim.lsp` lua API.

        You may also want to use [nvim-lspconfig] to install _default configs_ for many language servers.
        This can be installed using [`${options.plugins.lspconfig.enable}`][`plugins.lspconfig`].

        [nvim-lspconfig]: ${options.plugins.lspconfig.package.default.meta.homepage}
        [`plugins.lspconfig`]: https://nix-community.github.io/nixvim/plugins/lspconfig/index.html
      '';
      default = { };
      example = {
        "*".config = {
          root_markers = [ ".git" ];
          capabilities.textDocument.semanticTokens = {
            multilineTokenSupport = true;
          };
        };
        luals.enable = true;
        clangd = {
          enable = true;
          config = {
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
    in
    {
      extraPackages = builtins.catAttrs "package" enabledServers;

      lsp.luaConfig.content =
        let
          mkServerConfig =
            server:
            let
              luaName = toLuaObject server.name;
              luaCfg = toLuaObject server.config;
            in
            ''
              vim.lsp.config(${luaName}, ${luaCfg})
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
    };
}
