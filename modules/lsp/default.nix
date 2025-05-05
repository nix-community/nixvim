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
  };

  imports = [
    ./servers
    ./keymaps.nix
  ];

  config = {
    lsp.luaConfig.content = lib.mkIf cfg.inlayHints.enable "vim.lsp.inlay_hint.enable(true)";

    extraConfigLua = lib.mkIf (cfg.luaConfig.content != "") ''
      -- LSP {{{
      do
        ${cfg.luaConfig.content}
      end
      -- }}}
    '';
  };
}
