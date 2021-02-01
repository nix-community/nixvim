{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.lsp.servers.rust-analyzer;
in
{
  options = {
    programs.nixvim.plugins.lsp.servers.rust-analyzer = {
      enable = mkEnableOption "Enable rust-analyzer, for Rust.";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim.extraPackages = [ pkgs.rust-analyzer ];

    programs.nixvim.plugins.lsp.enabledServers = [ "rust_analyzer" ];
  };
}
