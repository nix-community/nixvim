{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.lsp.servers.clangd;
in
{
  options = {
    plugins.lsp.servers.clangd = {
      enable = mkEnableOption "Enable clangd LSP, for C/C++.";
    };
  };

  config = mkIf cfg.enable {
    extraPackages = [ pkgs.clang-tools ];

    plugins.lsp.enabledServers = [ "clangd" ];
  };
}
