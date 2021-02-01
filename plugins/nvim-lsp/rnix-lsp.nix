{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.lsp.servers.rnix-lsp;
in
{
  options = {
    programs.nixvim.plugins.lsp.servers.rnix-lsp = {
      enable = mkEnableOption "Enable rnix LSP, for Nix";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim.extraPackages = [ pkgs.rnix-lsp ];

    programs.nixvim.plugins.lsp.enabledServers = [ "rnix" ];
  };
}
