{
  self,
  lib,
  ...
}:
let
  inherit (lib.modules) importApply;
  # Added 2025-05-25; warning shown since 2025-08-01 (25.11)
  # NOTE: top-level binding of a fully resolved value, to avoid printing multiple times
  homeManagerModulesWarning = lib.warn "nixvim: flake output `homeManagerModules` has been renamed to `homeModules`." null;
in
{
  perSystem =
    { config, system, ... }:
    let
      inherit (config.legacyPackages) makeNixvimWithModule;
    in
    {
      legacyPackages = {
        makeNixvimWithModule = import ../wrappers/standalone.nix {
          inherit lib self;
          defaultSystem = system;
        };
        makeNixvim = module: makeNixvimWithModule { inherit module; };
      };
    };

  flake = {
    nixosModules = {
      nixvim = importApply ../wrappers/nixos.nix self;
      default = self.nixosModules.nixvim;
    };
    # Alias for backward compatibility
    homeManagerModules = lib.mapAttrs (_: lib.seq homeManagerModulesWarning) self.homeModules;
    homeModules = {
      nixvim = importApply ../wrappers/hm.nix self;
      default = self.homeModules.nixvim;
    };
    nixDarwinModules = {
      nixvim = importApply ../wrappers/darwin.nix self;
      default = self.nixDarwinModules.nixvim;
    };
  };
}
