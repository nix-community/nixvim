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
        (lib.filterAttrs (_: depOption: depOption.package ? example))
        (lib.mapAttrs (
          _: depOption:
          let
            packageName = depOption.package.example.text;
            packagePath = lib.splitString "." packageName;
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
