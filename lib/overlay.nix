# TODO: remove `args` and standardise how we build lib.nixvim
# Ideally, `lib` should be the _only_ argument expected by lib.nixvim
args:
# Extends nixpkg's lib with our functions, as expected by our modules
lib: prev: {
  # Include our custom lib
  nixvim = import ./. ({ inherit lib; } // args);

  # Merge in our maintainers
  maintainers = prev.maintainers // import ./maintainers.nix;

  # Merge in our custom types
  types = prev.types // import ./types.nix { inherit lib; };
}
