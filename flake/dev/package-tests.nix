{ lib, ... }:
{
  perSystem =
    { config, system, ... }:
    {
      # Test that all packages build fine when running `nix flake check`.
      checks = config.packages;

      # Test that all packages build when running buildbot
      # FIXME: we want to build most platforms on all systems,
      # but building the docs is often too expensive.
      # For now, we restrict the whole packages output to one platform.
      # TODO: move building the docs to GHA
      ci.buildbot = lib.mkIf (system == "x86_64-linux") config.packages;
    };
}
