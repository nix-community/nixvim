{ self, getHelpers }:
{
  pkgs,
  config,
  lib,
  ...
}@args:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkOptionType
    mkForce
    mkMerge
    mkIf
    types
    ;
  helpers = getHelpers pkgs false;
  shared = import ./_shared.nix helpers args;
  cfg = config.programs.nixvim;
in
{
  options = {
    programs.nixvim = mkOption {
      default = { };
      type = types.submoduleWith {
        shorthandOnlyDefinesConfig = true;
        specialArgs = {
          darwinConfig = config;
          defaultPkgs = pkgs;
          inherit helpers;
        };
        modules = [
          ./modules/darwin.nix
          ../modules/top-level
        ];
      };
    };
    nixvim.helpers = shared.helpers;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [
        cfg.finalPackage
        cfg.printInitPackage
      ] ++ (lib.optional cfg.enableMan self.packages.${pkgs.stdenv.hostPlatform.system}.man-docs);
    }
    { inherit (cfg) warnings assertions; }
  ]);
}
