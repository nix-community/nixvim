{ config, pkgs, lib, ...}:
with lib;
let
  cfg = config.plugins.lsp.servers.pyright;
in
{
  options = {
    plugins.lsp.servers.pyright = {
      enable = mkEnableOption "Enable pyright, for Python.";
    };
  };

  config = mkIf cfg.enable {
    extraPackages = [ pkgs.pyright ];

    plugins.lsp.enabledServers = [ "pyright"];
  };
}
