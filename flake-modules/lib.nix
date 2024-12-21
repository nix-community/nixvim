{
  self,
  config,
  lib,
  withSystem,
  ...
}:
{
  # Expose lib as a flake-parts module arg
  _module.args = {
    helpers = self.lib.nixvim;
  };

  # Public `lib` flake output
  flake.lib =
    {
      nixvim = lib.makeOverridable (import ../lib) {
        inherit lib;
        flake = self;
      };
      overlay = lib.makeOverridable (import ../lib/overlay.nix) {
        flake = self;
      };
    }
    // lib.genAttrs config.systems (
      lib.flip withSystem (
        { pkgs, system, ... }:
        {
          # NOTE: this is the publicly documented flake output we've had for a while
          check = pkgs.callPackage ../lib/tests.nix { inherit self; };

          # NOTE: no longer needs to be per-system
          helpers = lib.warn "nixvim: `<nixvim>.lib.${system}.helpers` has been moved to `<nixvim>.lib.nixvim` and no longer depends on a specific system" self.lib.nixvim;
        }
      )
    );
}
