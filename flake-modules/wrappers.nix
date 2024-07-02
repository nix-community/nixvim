{
  inputs,
  getHelpers,
  self,
  ...
}:
let
  wrapperArgs = {
    inherit self;
    inherit getHelpers;
  };
in
{
  perSystem =
    { system, pkgs, ... }:
    {
      _module.args = {
        makeNixvimWithModule = import ../wrappers/standalone.nix pkgs wrapperArgs;
      };

      checks =
        {
          home-manager-module =
            (import ../tests/modules/hm.nix {
              inherit pkgs;
              inherit (inputs) home-manager;
              nixvim = self;
            }).activationPackage;
        }
        // pkgs.lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
          nixos-module =
            (import ../tests/modules/nixos.nix {
              inherit system;
              inherit (inputs) nixpkgs;
              nixvim = self;
            }).config.system.build.toplevel;
        }
        // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
          darwin-module =
            (import ../tests/modules/darwin.nix {
              inherit system;
              inherit (inputs) nix-darwin;
              nixvim = self;
            }).system;
        };
    };

  flake = {
    nixosModules = {
      nixvim = import ../wrappers/nixos.nix wrapperArgs;
      default = self.nixosModules.nixvim;
    };
    homeManagerModules = {
      nixvim = import ../wrappers/hm.nix wrapperArgs;
      default = self.homeManagerModules.nixvim;
    };
    nixDarwinModules = {
      nixvim = import ../wrappers/darwin.nix wrapperArgs;
      default = self.nixDarwinModules.nixvim;
    };
  };
}
