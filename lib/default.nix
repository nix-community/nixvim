# Args probably only needs pkgs and lib
{
  makeNixvim,
  pkgs,
  ...
} @ args: {
  # Add all exported modules here
  check = import ../tests/test-derivation.nix {
    inherit makeNixvim pkgs;
  };
  helpers = import ./helpers.nix args;
}
