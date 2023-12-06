{
  perSystem = {
    pkgs,
    pkgsUnfree,
    config,
    modules,
    ...
  }: {
    packages = let
      docs = {
        docs = pkgsUnfree.callPackage (import ../docs) {
          inherit modules;
        };
      };

      man-docs = import ../man-docs {
        pkgs = pkgsUnfree;
        inherit modules;
      };

      # TODO: deprecate (unused)
      helpers = import ../helpers pkgs;
    in
      docs
      // man-docs
      // helpers;
  };
}
