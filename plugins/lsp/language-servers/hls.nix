{
  lib,
  pkgs,
  config,
  options,
  ...
}:
let
  cfg = config.plugins.lsp.servers.hls;
  opts = options.plugins.lsp.servers.hls;
  enabled = config.plugins.lsp.enable && cfg.enable;

  # The new `installGhc` option doesn't support null values, so check how the old value is defined
  installGhcValue =
    lib.modules.mergeDefinitions opts.installGhc.loc opts.installGhc.type
      opts.installGhc.definitionsWithLocations;
  useInstallGhcValue = installGhcValue.optionalValue.value or null != null;
in
{
  options.plugins.lsp.servers.hls = {
    installGhc = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      example = true;
      description = "Whether to install `ghc`.";
      apply = v: if enabled then config.lsp.servers.hls.installGhc else v;
    };

    ghcPackage = lib.mkPackageOption pkgs "ghc" { } // {
      apply = v: if enabled then config.lsp.servers.hls.ghcPackage else v;
    };
  };

  config = lib.mkIf enabled {
    lsp.servers.hls = {
      installGhc = lib.mkIf useInstallGhcValue (
        lib.modules.mkAliasAndWrapDefsWithPriority lib.id opts.installGhc
      );
      ghcPackage = lib.mkIf (opts.ghcPackage.highestPrio < 1500) (
        lib.modules.mkAliasAndWrapDefsWithPriority lib.id opts.ghcPackage
      );
    };
  };
}
