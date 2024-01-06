{
  perSystem = {
    pkgs,
    pkgsUnfree,
    config,
    modules,
    ...
  }: {
    packages = let
      # Do not check if documentation builds fine on darwin as it fails:
      # > sandbox-exec: pattern serialization length 69298 exceeds maximum (65535)
      docs = pkgs.lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
        docs = pkgsUnfree.callPackage (import ../docs) {
          inherit modules;
        };
      };

      man-docs = import ../man-docs {
        pkgs = pkgsUnfree;
        inherit modules;
      };
    in
      docs
      // man-docs;

    # Test that all packages build fine when running `nix flake check`.
    checks = config.packages;
  };
}
