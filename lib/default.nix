# Args probably only needs pkgs and lib
{
  flake,
  pkgs,
  lib ? pkgs.lib,
  _nixvimTests ? false,
}@args:
lib.fix (self: {
  # Add all exported modules here
  check = import ./tests.nix { inherit lib pkgs; };
  helpers = import ./helpers.nix (args // { inherit _nixvimTests; });

  # TODO: Consider renaming these?
  makeNixvimWithModule = import ../wrappers/standalone.nix pkgs flake;
  makeNixvim = module: self.makeNixvimWithModule { inherit module; };
})
