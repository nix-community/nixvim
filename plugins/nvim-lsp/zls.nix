{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.plugins.lsp.servers.zls;
in
{
  options = {
    plugins.lsp.servers.zls = {
      enable = mkEnableOption "Enable zls, for Zig.";
    };
  };

  config = mkIf cfg.enable {
    extraPackages = [ pkgs.zls ];

    plugins.lsp.enabledServers = [ "zls" ];
  };
}
