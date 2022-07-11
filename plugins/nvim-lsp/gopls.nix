{ config, pkgs, lib, ...}:
with lib;
let
  cfg = config.programs.nixvim.plugins.lsp.servers.gopls;
in
{
  options = {
    programs.nixvim.plugins.lsp.servers.gopls = {
      enable = mkEnableOption "Enable gopls, for Go.";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim.extraPackages = [ pkgs.gopls ];

    programs.nixvim.plugins.lsp.enabledServers = [ "gopls" ];
  };
}
