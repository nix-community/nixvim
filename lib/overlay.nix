{ flake }:
final: prev: {
  # Include our custom lib
  nixvim = flake.lib.nixvim.override {
    lib = final;
    _isExtended = true;
  };

  # Merge in our maintainers
  maintainers = prev.maintainers // import ./maintainers.nix;

  # Merge in our custom types
  types = prev.types // import ./types.nix { lib = final; };
}
