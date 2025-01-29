{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.plugins.lsp.servers.hls;
  inherit (lib) types;
in
{
  options.plugins.lsp.servers.hls = {
    installGhc = lib.mkOption {
      type = with types; nullOr bool;
      default = null;
      example = true;
      description = "Whether to install `ghc`.";
    };

    ghcPackage = lib.mkPackageOption pkgs "ghc" { };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.nixvim.mkWarnings "plugins.lsp.servers.hls" {
      when = cfg.installGhc == null;
      message = ''
        `hls` relies on `ghc` (the Glasgow Haskell Compiler).
        - Set `plugins.lsp.servers.hls.installGhc = true` to install it automatically with Nixvim.
          You can customize which package to install by changing `plugins.lsp.servers.hls.ghcPackage`.
        - Set `plugins.lsp.servers.hls.installGhc = false` to not have it install through Nixvim.
          By doing so, you will dismiss this warning.
      '';
    };

    extraPackages = lib.optional (cfg.installGhc == true) cfg.ghcPackage;
  };
}
