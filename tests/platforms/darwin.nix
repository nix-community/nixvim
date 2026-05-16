{
  self,
  system,
  lib,
}:
let
  darwinSystem = import (self.inputs.nix-darwin + "/eval-config.nix");
in
darwinSystem {
  inherit lib;

  modules = [
    (
      { config, ... }:
      {
        nixpkgs = {
          source = self.inputs.nixpkgs;
          hostPlatform = system;
        };

        programs.nixvim = {
          enable = true;
        };

        system.stateVersion = config.system.maxStateVersion;
      }
    )
    self.nixDarwinModules.nixvim
  ];
}
