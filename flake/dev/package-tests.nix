{
  perSystem =
    { config, ... }:
    {
      # Test that all packages build fine when running `nix flake check`.
      checks = config.packages;

      # Test that all packages build when running buildbot
      # TODO: only test the docs on x86_64-linux
      ci.buildbot = config.packages;
    };
}
