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
    # For backward compatibility
    homeManagerModules = self.homeModules;
    homeModules = {
      nixvim = import ../wrappers/hm.nix self;
      default = self.homeModules.nixvim;
    };
    nixDarwinModules = {
      nixvim = import ../wrappers/darwin.nix self;
      default = self.nixDarwinModules.nixvim;
    };
  };
}
