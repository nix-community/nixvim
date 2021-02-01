{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.lsp.servers.clangd;
in
{
  options = {
    programs.nixvim.plugins.lsp.servers.clangd = {
      enable = mkEnableOption "Enable clangd LSP, for C/C++.";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim.extraPackages = [ pkgs.clang-tools ];

    programs.nixvim.plugins.lsp.enabledServers = [ "clangd" ];
  };
}
