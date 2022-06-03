{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.lsp.servers.rust-analyzer;
in
{
  options = {
    plugins.lsp.servers.rust-analyzer = {
      enable = mkEnableOption "Enable rust-analyzer, for Rust.";
    };
  };

  config = mkIf cfg.enable {
    extraPackages = [ pkgs.rust-analyzer ];

    plugins.lsp.enabledServers = [ "rust_analyzer" ];
  };
}
