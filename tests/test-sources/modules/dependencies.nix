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
}
