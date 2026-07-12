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
  };

in
import nixpkgs {
  inherit system;
  overlays = [ overlay ];
}
