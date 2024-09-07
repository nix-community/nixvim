{ self, lib, ... }:
{
  perSystem =
    {
      self',
      pkgs,
      pkgsUnfree,
      system,
      ...
    }:
    let
      inherit (self'.legacyPackages.lib) helpers makeNixvimWithModule;
      callTest = lib.callPackageWith (
        pkgs
        // {
          nixvimLib = self'.legacyPackages.lib;
          inherit helpers makeNixvimWithModule;
          inherit (self'.legacyPackages.lib.check) mkTestDerivationFromNvim mkTestDerivationFromNixvimModule;
          evaluatedNixvim = helpers.modules.evalNixvim { check = false; };
        }
      );
    in
    {
      checks = {
        extra-args-tests = callTest ../tests/extra-args.nix { };
        extend = callTest ../tests/extend.nix { };
        extra-files = callTest ../tests/extra-files.nix { };
        enable-except-in-tests = callTest ../tests/enable-except-in-tests.nix { };
        failing-tests = callTest ../tests/failing-tests.nix { };
        no-flake = callTest ../tests/no-flake.nix {
          inherit system;
          nixvim = "${self}";
        };
        lib-tests = callTest ../tests/lib-tests.nix { };
        maintainers = callTest ../tests/maintainers.nix { };
        generated = callTest ../tests/generated.nix { };
        package-options = callTest ../tests/package-options.nix { };
      } // callTest ../tests { inherit pkgsUnfree; };
    };
}
