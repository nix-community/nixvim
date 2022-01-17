{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.lsp.servers.zls;
in
{
  options = {
    programs.nixvim.plugins.lsp.server.zls = {
      enable = mkEnableOption "Enable zls, LSP support for Zig";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim.extraPackages = [ pkgs.zls ];

    programs.nixvim.plugins.lsp.enabledServers = [ "zls" ];
  };
}
