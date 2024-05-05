{
  perSystem =
    {
      pkgs,
      config,
      rawModules,
      helpers,
      ...
    }:
    {
      packages = import ../docs { inherit rawModules pkgs helpers; };

      # Test that all packages build fine when running `nix flake check`.
      checks = config.packages;
    };
}
