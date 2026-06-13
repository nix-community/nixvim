{
  lib,
  pkgs,
  config,
  options,
  ...
}:
{
  options = {
    installGhc = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Whether to install `ghc`.";
    };

    ghcPackage = lib.mkPackageOption pkgs "ghc" { };
  };

  config = lib.mkIf config.enable {
    warnings = lib.nixvim.mkWarnings "lsp.servers.hls" {
      when = options.installGhc.highestPrio == 1500;
      message = ''
        `hls` relies on `ghc` (the Glasgow Haskell Compiler).
        - Set `${options.installGhc} = true` to install it automatically with Nixvim.
          You can customize which package to install by changing `${options.ghcPackage}`.
        - Set `${options.installGhc} = false` to not have it install through Nixvim.
          By doing so, you will dismiss this warning.
      '';
    };

    packages = lib.mkIf config.installGhc {
      ${if config.packageFallback then "suffix" else "prefix"} = [
        config.ghcPackage
      ];
    };
  };
}
