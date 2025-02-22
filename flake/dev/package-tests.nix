{
  perSystem =
    { config, ... }:
    {
      # Test that all packages build fine when running `nix flake check`.
      checks = config.packages;
    };
}
