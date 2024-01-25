{
  perSystem = {
    pkgs,
    config,
    modulesUnfree,
    pkgsUnfree,
    ...
  }: {
    packages = import ../docs {
      modules = modulesUnfree;
      pkgs = pkgsUnfree;
      inherit (pkgs) lib;
    };

    # Test that all packages build fine when running `nix flake check`.
    checks = config.packages;
  };
}
