{
  override =
    { pkgs, ... }:
    {
      dependencies.git = {
        enable = true;
        package = pkgs.gitMinimal;
      };
    };

  all =
    {
      lib,
      pkgs,
      options,
      ...
    }:
    {
      dependencies = lib.mapAttrs (_: depOption: {
        enable = lib.meta.availableOn pkgs.stdenv.hostPlatform depOption.package.default;
      }) options.dependencies;
    };

  all-examples =
    {
      lib,
      pkgs,
      options,
      ...
    }:
    {
      dependencies = lib.pipe options.dependencies [
        # We use a literalExpression example, with an additional `path` attr.
        # This means we don't have to convert human readable paths back to list-paths for this test.
        (lib.filterAttrs (_: depOption: depOption.package ? example.path))
        (lib.mapAttrs (
          _: depOption:
          let
            packagePath = depOption.package.example.path;
            packageName = lib.showAttrPath packagePath;
            package = lib.attrByPath packagePath (throw "${packageName} not found in pkgs") pkgs;
          in
          {
            enable = lib.meta.availableOn pkgs.stdenv.hostPlatform package;
            inherit package;
          }
        ))
      ];
    };
}
