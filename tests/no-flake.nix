{
  nixvim ? "${self}",
  self ? throw "either supply `self` or `nixvim`",
  system,
  mkTestDerivationFromNvim,
}:
let
  # This simulates the `default.nix`, but in a pure way so because we are currently in a flake.
  nixvim' =
    (import (
      let
        lock = builtins.fromJSON (builtins.readFile ../flake/dev/flake.lock);
      in
      fetchTarball {
        url =
          lock.nodes.flake-compat.locked.url
            or "https://github.com/NixOS/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
        sha256 = lock.nodes.flake-compat.locked.narHash;
      }
    ) { src = nixvim; }).defaultNix;

  config = {
    colorschemes.gruvbox.enable = true;
  };

  nvim = nixvim'.legacyPackages."${system}".makeNixvim config;
in
mkTestDerivationFromNvim {
  name = "no-flakes";
  inherit nvim;
}
