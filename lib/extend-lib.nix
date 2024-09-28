# Extends nixpkg's lib with our functions, as expected by our modules
{
  lib,
  self ? import ./. { inherit lib; },
}:
lib.extend (
  final: prev: {
    # Include our custom lib
    nixvim = self.public;

    # Merge in our maintainers
    maintainers = prev.maintainers // import ./maintainers.nix;

    # Merge in our custom types
    types = prev.types // self.types;
  }
)
