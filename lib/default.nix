# Args probably only needs pkgs and lib
{
  makeNixvimWithModule,
  pkgs,
  lib ? pkgs.lib,
  ...
}@args:
{
  # Add all exported modules here
  check = import ../tests/test-derivation.nix { inherit makeNixvimWithModule lib pkgs; };
  helpers = import ./helpers.nix { inherit pkgs lib; };
}
