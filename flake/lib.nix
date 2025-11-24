{
  self,
  config,
  lib,
  withSystem,
  ...
}:
{
  # Public `lib` flake output
  flake.lib = {
    nixvim = lib.makeOverridable ({ lib }: (lib.extend self.lib.overlay).nixvim) {
      inherit lib;
    };
    overlay = import ../lib/overlay.nix {
      flake = self;
    };
    # Top-top-level aliases
    inherit (self.lib.nixvim)
      evalNixvim
      ;
  }
  // lib.genAttrs config.systems (
    lib.flip withSystem (
      { pkgs, system, ... }:
      {
        # NOTE: this is the publicly documented flake output we've had for a while
        check = pkgs.callPackage ../lib/tests.nix {
          inherit lib self system;
        };

        # NOTE: no longer needs to be per-system
        helpers = lib.warn "nixvim: `<nixvim>.lib.${system}.helpers` has been moved to `<nixvim>.lib.nixvim` and no longer depends on a specific system" self.lib.nixvim;
      }
    )
  );
}
