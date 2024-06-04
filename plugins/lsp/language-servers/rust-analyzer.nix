{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.lsp.servers.rust-analyzer;
in {
  options.plugins.lsp.servers.rust-analyzer = {
    # https://github.com/nix-community/nixvim/issues/674
    installCargo = mkOption {
      type = with types; nullOr bool;
      default = null;
      example = true;
      description = "Whether to install `cargo`.";
    };

    cargoPackage = mkOption {
      type = types.package;
      default = pkgs.cargo;
      description = "Which package to use for `cargo`.";
    };

    installRustc = mkOption {
      type = with types; nullOr bool;
      default = null;
      example = true;
      description = "Whether to install `rustc`.";
    };

    rustcPackage = mkOption {
      type = types.package;
      default = pkgs.rustc;
      description = "Which package to use for `rustc`.";
    };
  };
  config = mkIf cfg.enable {
    warnings =
      (optional (cfg.installCargo == null) ''
        `rust_analyzer` relies on `cargo`.
        - Set `plugins.lsp.servers.rust-analyzer.installCargo = true` to install it automatically
          with Nixvim.
          You can customize which package to install by changing
          `plugins.lsp.servers.rust-analyzer.cargoPackage`.
        - Set `plugins.lsp.servers.rust-analyzer.installCargo = false` to not have it install
          through Nixvim.
          By doing so, you will dismiss this warning.
      '')
      ++ (optional (cfg.installRustc == null) ''
        `rust_analyzer` relies on `rustc`.
        - Set `plugins.lsp.servers.rust-analyzer.installRustc = true` to install it automatically
          with Nixvim.
          You can customize which package to install by changing
          `plugins.lsp.servers.rust-analyzer.rustcPackage`.
        - Set `plugins.lsp.servers.rust-analyzer.installRustc = false` to not have it install
          through Nixvim.
          By doing so, you will dismiss this warning.
      '');

    extraPackages = with pkgs;
      (optional ((isBool cfg.installCargo) && cfg.installCargo) cfg.cargoPackage)
      ++ (optional ((isBool cfg.installRustc) && cfg.installRustc) cfg.rustcPackage);
  };
}
