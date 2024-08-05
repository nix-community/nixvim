# Args probably only needs pkgs and lib
{
  pkgs,
  lib ? pkgs.lib,
  _nixvimTests ? false,
  ...
}@args:
{
  # Add all exported modules here
  check = import ./tests.nix { inherit lib pkgs; };
  helpers = import ./helpers.nix (args // { inherit _nixvimTests; });
}
