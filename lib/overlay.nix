# TODO: remove `args` and standardise how we build lib.nixvim
# Ideally, `lib` should be the _only_ argument expected by lib.nixvim
{
  self ? null,
}:
# Extends nixpkg's lib with our functions, as expected by our modules
final: prev: {
  # Include our custom lib
  # To avoid redundant work, we allow a nixvim-lib instance to be supplied
  # TODO: is this needed, or would nix's laziness do the same thing automagically?
  nixvim = if self != null then self else import ./. {
    # TODO: final vs prev here...
    lib = prev;
  };

  # Merge in our maintainers
  maintainers = prev.maintainers // import ./maintainers.nix;

  # Merge in our custom types
  types = prev.types // import ./types.nix {
    lib = final;
  };
}
