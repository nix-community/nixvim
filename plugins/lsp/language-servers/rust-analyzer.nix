{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.lsp.servers.rust_analyzer;
in
{
  options.plugins.lsp.servers.rust_analyzer = {
    # https://github.com/nix-community/nixvim/issues/674
    installCargo = mkOption {
      type = with types; nullOr bool;
      default = null;
      example = true;
      description = "Whether to install `cargo`.";
    };

    # TODO: make nullable?
    cargoPackage = mkPackageOption pkgs "cargo" { };

    installRustc = mkOption {
      type = with types; nullOr bool;
      default = null;
      example = true;
      description = "Whether to install `rustc`.";
    };

    # TODO: make nullable
    rustcPackage = mkPackageOption pkgs "rustc" { };

    installRustfmt = mkOption {
      type = with types; nullOr bool;
      default = null;
      example = true;
      description = "Whether to install `rustfmt`.";
    };

    # TODO: make nullable
    rustfmtPackage = mkPackageOption pkgs "rustfmt" { };
  };
  config = mkIf cfg.enable {
    warnings =
      (optional (cfg.installCargo == null) ''
        `rust_analyzer` relies on `cargo`.
        - Set `plugins.lsp.servers.rust_analyzer.installCargo = true` to install it automatically
          with Nixvim.
          You can customize which package to install by changing
          `plugins.lsp.servers.rust_analyzer.cargoPackage`.
        - Set `plugins.lsp.servers.rust_analyzer.installCargo = false` to not have it install
          through Nixvim.
          By doing so, you will dismiss this warning.
      '')
      ++ (optional (cfg.installRustc == null) ''
        `rust_analyzer` relies on `rustc`.
        - Set `plugins.lsp.servers.rust_analyzer.installRustc = true` to install it automatically
          with Nixvim.
          You can customize which package to install by changing
          `plugins.lsp.servers.rust_analyzer.rustcPackage`.
        - Set `plugins.lsp.servers.rust_analyzer.installRustc = false` to not have it install
          through Nixvim.
          By doing so, you will dismiss this warning.
      '');

    extraPackages =
      with pkgs;
      optional (isBool cfg.installCargo && cfg.installCargo) cfg.cargoPackage
      ++ optional (isBool cfg.installRustc && cfg.installRustc) cfg.rustcPackage
      ++ optional (isBool cfg.installRustfmt && cfg.installRustfmt) cfg.rustfmtPackage;
  };
}
