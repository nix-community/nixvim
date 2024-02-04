{
  perSystem = {
    pkgs,
    config,
    rawModules,
    ...
  }: {
    packages = import ../docs {
      inherit rawModules pkgs;
    };

    # Test that all packages build fine when running `nix flake check`.
    checks = config.packages;
  };
}
