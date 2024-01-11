{
  perSystem = {
    pkgs,
    config,
    modules,
    ...
  }: {
    packages = import ../docs {
      inherit modules pkgs;
      inherit (pkgs) lib;
    };

    # Test that all packages build fine when running `nix flake check`.
    checks = config.packages;
  };
}
