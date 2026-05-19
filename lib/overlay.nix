# Public non-flake entrypoint for Nixvim's Nixpkgs-lib overlay
import ./overlay.internal.nix {
  flake = null;
}
