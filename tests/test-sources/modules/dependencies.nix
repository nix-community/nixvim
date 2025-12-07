{ lib, pkgs }:
let
  inherit (pkgs.stdenv) hostPlatform;

  disabledDeps = [
    # TODO: 2025-10-03
    # Transient dependency `vmr` has a build failure
    # https://github.com/NixOS/nixpkgs/issues/431811
    "roslyn_ls"
  ];

  isDepEnabled =
    name: package:
    # Filter disabled dependencies
    (!lib.elem name disabledDeps)

    # Disable if the package is not compatible with hostPlatform
    && lib.meta.availableOn hostPlatform package;
in
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
    { lib, options, ... }:
    let
      enableDep = depName: depOption: {
        enable = isDepEnabled depName depOption.package.default;
      };
    in
    {
      dependencies = lib.mapAttrs enableDep options.dependencies;
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
          depName: depOption:
          let
            packagePath = depOption.package.example.path;
            packageName = lib.showAttrPath packagePath;
            package = lib.attrByPath packagePath (throw "${packageName} not found in pkgs") pkgs;
          in
          {
            enable = isDepEnabled depName package;
            inherit package;
          }
        ))
      ];
    };

  # Integration test for `lib.nixvim.deprecation.mkRemovedPackageOptionModule`
  removed-package-options =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      test = {
        buildNixvim = false;
        warnings = expect: [
          (expect "count" 1)

          (expect "any" "The option `plugins.efmls-configs.efmLangServerPackage' defined in `")
          (expect "any" "has been replaced by `dependencies.efm-langserver.enable' and `dependencies.efm-langserver.package'.")
        ];
      };

      plugins.efmls-configs.efmLangServerPackage = null;

      assertions = [
        {
          assertion = !lib.elem pkgs.efm-langserver config.extraPackages;
          message = "Expected efm-langserver not to be installed.";
        }
      ];
    };
}
