{
  inputs,
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

      checks =
        {
          home-manager-module =
            (import ../tests/modules/hm.nix {
              inherit pkgs;
              inherit (inputs) home-manager;
              nixvim = self;
            }).activationPackage;
          home-manager-extra-files-byte-compiling =
            import ../tests/modules/hm-extra-files-byte-compiling.nix
              {
                inherit pkgs;
                inherit (inputs) home-manager;
                nixvim = self;
              };
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
