# Extends nixpkg's lib with our functions, as expected by our modules
{
  call,
  lib,
  helpers,
}:
lib.extend (
  final: prev: {
    # Include our custom lib
    nixvim = helpers;

    # Merge in our maintainers
    maintainers = prev.maintainers // import ./maintainers.nix;

    # Merge in our custom types
    types = prev.types // call ./types.nix { };
  }
)
