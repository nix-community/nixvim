{
  self,
  lib,
  ...
}:
{
  perSystem =
    { system, pkgs, ... }:
    {
      _module.args = {
        makeNixvimWithModule = import ../wrappers/standalone.nix {
          inherit lib self;
          defaultSystem = system;
        };
      };
    };

  flake = {
    nixosModules = {
      nixvim = import ../wrappers/nixos.nix self;
      default = self.nixosModules.nixvim;
    };
    homeManagerModules = {
      nixvim = import ../wrappers/hm.nix self;
      default = self.homeManagerModules.nixvim;
    };
    nixDarwinModules = {
      nixvim = import ../wrappers/darwin.nix self;
      default = self.nixDarwinModules.nixvim;
    };
  };
}
