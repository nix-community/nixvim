{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.lsp.servers.rnix-lsp;
in
{
  options = {
    plugins.lsp.servers.rnix-lsp = {
      enable = mkEnableOption "Enable rnix LSP, for Nix";
    };
  };

  config = mkIf cfg.enable {
    extraPackages = [ pkgs.rnix-lsp ];

    plugins.lsp.enabledServers = [ "rnix" ];
  };
}
