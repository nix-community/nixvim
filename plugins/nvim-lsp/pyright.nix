{ config, pkgs, lib, ...}:
with lib;
let
  cfg = config.programs.nixvim.plugins.lsp.servers.pyright;
in
{
  options = {
    programs.nixvim.plugins.lsp.servers.pyright = {
      enable = mkEnableOption "Enable pyright, for Python.";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim.extraPackages = [ pkgs.pyright ];

    programs.nixvim.plugins.lsp.enabledServers = [ "pyright"];
  };
}
