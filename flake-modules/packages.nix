{ getHelpers, ... }:
{
  perSystem =
    { pkgsUnfree, config, ... }:
    {
      packages = import ../docs {
        inherit getHelpers;
        # Building the docs evaluates each plugin's default package, some of which are unfree
        pkgs = pkgsUnfree;
      };

      # Test that all packages build fine when running `nix flake check`.
      checks = config.packages;
    };
}
