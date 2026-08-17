{ lib, config, ... }:
let
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
    codelens = {
      enable = lib.mkEnableOption null // {
        description = ''
          Whether to enable codelens globally.

          See [`:h lsp-codelens`](https://neovim.io/doc/user/lsp/#lsp-codelens)
        '';
      };
    };
  };

  imports = [
    ./servers
    ./keymaps.nix
    ./on-attach.nix
  ];

  config = {
    lsp.luaConfig.content = lib.mkMerge [
      (lib.mkIf cfg.inlayHints.enable "vim.lsp.inlay_hint.enable(true)")
      (lib.mkIf cfg.codelens.enable "vim.lsp.codelens.enable(true)")
    ];

    extraConfigLua = lib.mkIf (cfg.luaConfig.content != "") ''
      -- LSP {{{
      do
        ${cfg.luaConfig.content}
      end
      -- }}}
    '';
  };
}
