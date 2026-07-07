{
  system,
  nixpkgs,
}:
let
  # Extend nixpkg's lib, so that we can handle recursive leaf types such as `either`
  libOverlay = final: prev: {
    types = prev.types // {
      either =
        t1: t2:
        prev.types.either t1 t2
        // {
          getSubOptions = prefix: t1.getSubOptions prefix // t2.getSubOptions prefix;
        };
    };
  };

  overlay = final: prev: {
    lib = prev.lib.extend libOverlay;

    nixos-render-docs = prev.nixos-render-docs.overrideAttrs (old: {
      patches = old.patches or [ ] ++ [
        (final.fetchpatch {
          name = "extend-admonition-support.patch";
          url = "https://github.com/NixOS/nixpkgs/pull/538502.patch";
          hash = "sha256-rhAp95lH5fPvdtylIDx+LazoCtgfhs4AOaq8CagTfZ8=";
          stripLen = 5;
        })
      ];
    });
  };

in
import nixpkgs {
  inherit system;
  overlays = [ overlay ];
}
