# Extends nixpkg's lib with our functions, as expected by our modules
{ lib, helpers }:
lib.extend (
  final: prev: {
    # Include our custom lib
    nixvim = helpers;

    # Merge in our maintainers
    maintainers = prev.maintainers // import ./maintainers.nix;
  }
)
