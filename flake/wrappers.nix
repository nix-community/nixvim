{
  self,
  lib,
  ...
}:
let
  inherit (lib.modules) importApply;
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
    # Added 2025-05-25 in https://github.com/nix-community/nixvim/pull/3387
    homeManagerModules =
      let
        cond = lib.trivial.oldestSupportedReleaseIsAtLeast 2505;
        msg = "nixvim: flake output `homeManagerModules` has been renamed to `homeModules`.";
      in
      lib.warnIf cond msg self.homeModules;
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
