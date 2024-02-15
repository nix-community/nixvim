# Args probably only needs pkgs and lib
{
  makeNixvim,
  makeNixvimWithModule,
  pkgs,
  ...
} @ args: {
  # Add all exported modules here
  check = import ../tests/test-derivation.nix {
    inherit makeNixvim makeNixvimWithModule pkgs;
  };
  helpers = import ./helpers.nix args;
}
