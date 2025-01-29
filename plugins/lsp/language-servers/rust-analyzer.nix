{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.plugins.lsp.servers.rust_analyzer;
  inherit (lib) mkPackageOption types;
  inherit (lib.nixvim) mkNullOrOption' isTrue;

in
{
  options.plugins.lsp.servers.rust_analyzer = {
    # https://github.com/nix-community/nixvim/issues/674
    installCargo = mkNullOrOption' {
      type = types.bool;
      example = true;
      description = "Whether to install `cargo`.";
    };

    # TODO: make nullable?
    cargoPackage = lib.mkPackageOption pkgs "cargo" { };

    installRustc = mkNullOrOption' {
      type = types.bool;
      example = true;
      description = "Whether to install `rustc`.";
    };

    # TODO: make nullable
    rustcPackage = mkPackageOption pkgs "rustc" { };

    installRustfmt = mkNullOrOption' {
      type = types.bool;
      example = true;
      description = "Whether to install `rustfmt`.";
    };

    # TODO: make nullable
    rustfmtPackage = mkPackageOption pkgs "rustfmt" { };
  };
  config = lib.mkIf cfg.enable {
    warnings = lib.nixvim.mkWarnings "plugins.lsp.servers.rust_analyzer" [
      {
        when = cfg.installCargo == null;

        message = ''
          `rust_analyzer` relies on `cargo`.
          - Set `plugins.lsp.servers.rust_analyzer.installCargo = true` to install it automatically
            with Nixvim.
            You can customize which package to install by changing
            `plugins.lsp.servers.rust_analyzer.cargoPackage`.
          - Set `plugins.lsp.servers.rust_analyzer.installCargo = false` to not have it install
            through Nixvim.
            By doing so, you will dismiss this warning.
        '';
      }
      {
        when = cfg.installRustc == null;

        message = ''
          `rust_analyzer` relies on `rustc`.
          - Set `plugins.lsp.servers.rust_analyzer.installRustc = true` to install it automatically
            with Nixvim.
            You can customize which package to install by changing
            `plugins.lsp.servers.rust_analyzer.rustcPackage`.
          - Set `plugins.lsp.servers.rust_analyzer.installRustc = false` to not have it install
            through Nixvim.
            By doing so, you will dismiss this warning.
        '';
      }
    ];

    extraPackages =
      lib.optional (isTrue cfg.installCargo) cfg.cargoPackage
      ++ lib.optional (isTrue cfg.installRustc) cfg.rustcPackage
      ++ lib.optional (isTrue cfg.installRustfmt) cfg.rustfmtPackage;
  };
}
