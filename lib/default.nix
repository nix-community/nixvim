# Args probably only needs pkgs and lib
{
  makeNixvim,
  makeNixvimWithModule,
  pkgs,
  _nixvimTests ? false,
  ...
} @ args: {
  # Add all exported modules here
  check = import ../tests/test-derivation.nix {inherit makeNixvim makeNixvimWithModule pkgs;};
  helpers = import ./helpers.nix (args // {inherit _nixvimTests;});
}
