# Extends nixpkg's lib with our functions, as expected by our modules
{
  call,
  lib,
  self,
}:
lib.extend (
  final: prev: {
    # Include our custom lib
    nixvim = self;

    # Merge in our maintainers
    maintainers = prev.maintainers // import ./maintainers.nix;

    # Merge in our custom types
    types = prev.types // call ./types.nix { };
  }
)
