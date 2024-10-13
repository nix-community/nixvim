{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.lsp.servers.hls;
in
{
  options.plugins.lsp.servers.hls = {
    installGhc = mkOption {
      type = with types; nullOr bool;
      default = null;
      example = true;
      description = "Whether to install `ghc`.";
    };

    ghcPackage = mkPackageOption pkgs "ghc" { };
  };

  config = mkIf cfg.enable {
    warnings = optional (cfg.installGhc == null) ''
      `hls` relies on `ghc` (the Glasgow Haskell Compiler).
      - Set `plugins.lsp.servers.hls.installGhc = true` to install it automatically with Nixvim.
        You can customize which package to install by changing `plugins.lsp.servers.hls.ghcPackage`.
      - Set `plugins.lsp.servers.hls.installGhc = false` to not have it install through Nixvim.
        By doing so, you will dismiss this warning.
    '';

    extraPackages = with pkgs; (optional ((isBool cfg.installGhc) && cfg.installGhc) cfg.ghcPackage);
  };
}
