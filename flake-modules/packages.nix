{
  perSystem =
    {
      pkgsUnfree,
      config,
      helpers,
      ...
    }:
    {
      packages = import ../docs {
        inherit helpers;
        # Building the docs evaluates each plugin's default package, some of which are unfree
        pkgs = pkgsUnfree;
      };

      # Test that all packages build fine when running `nix flake check`.
      checks = config.packages;
    };
}
