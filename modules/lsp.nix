{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (lib.nixvim) toLuaObject;

  cfg = config.lsp;

  serverType = types.submodule {
    options = {
      enable = lib.mkEnableOption "the language server";

      activate = lib.mkOption {
        type = types.bool;
        description = ''
          Whether to call `vim.lsp.enable()` for this server.
        '';
        default = true;
        example = false;
      };

      package = lib.mkOption {
        type = with types; nullOr package;
        default = null;
        description = ''
          Package to use for this language server.

          Alternatively, the language server should be available on your `$PATH`.
        '';
      };

      config = mkOption {
        type = with types; attrsOf anything;
        description = ''
          Configurations for each language server.
        '';
        default = { };
        example = {
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

    servers = mkOption {
      type = types.attrsOf serverType;
      description = ''
        LSP servers to enable and/or configure.

        This option is implemented using neovim's `vim.lsp` lua API.
        If you prefer to use [nvim-lspconfig], see [`plugins.lsp`].

        [nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
        [`plugins.lsp`]: https://nix-community.github.io/nixvim/plugins/lsp/index.html
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
      enabledServers = lib.filterAttrs (_: v: v.enable) cfg.servers;
    in
    {
      extraPackages = lib.pipe enabledServers [
        builtins.attrValues
        (builtins.catAttrs "package")
      ];

      lsp.luaConfig.content =
        let
          mkServerConfig =
            name: props:
            let
              luaName = toLuaObject name;
            in
            ''
              vim.lsp.config(${luaName}, ${toLuaObject props.config})
            ''
            + lib.optionalString props.activate ''
              vim.lsp.enable(${luaName})
            '';
        in
        lib.mkMerge (
          lib.optional cfg.inlayHints.enable "vim.lsp.inlay_hint.enable(true)"
          ++ lib.mapAttrsToList mkServerConfig enabledServers
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
