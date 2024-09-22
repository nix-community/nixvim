self:
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
  cfg = config.programs.nixvim;
in
{
  options = {
    programs.nixvim = mkOption {
      default = { };
      type = types.submoduleWith {
        shorthandOnlyDefinesConfig = true;
        specialArgs = config.lib.nixvim.modules.specialArgsWith {
          defaultPkgs = pkgs;
          darwinConfig = config;
        };
        modules = [
          ./modules/darwin.nix
          ../modules/top-level
          # TODO: maybe don't do this by default?
          { nixpkgs.pkgs = pkgs; }
        ];
      };
    };
  };

  imports = [ (import ./_shared.nix { }) ];

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
