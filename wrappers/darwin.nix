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
  nixvimConfig = config.lib.nixvim.modules.evalNixvim {
    extraSpecialArgs = {
      defaultPkgs = pkgs;
      darwinConfig = config;
    };
    modules = [
      ./modules/darwin.nix
    ];
    check = false;
  };
in
{
  options = {
    programs.nixvim = mkOption {
      inherit (nixvimConfig) type;
      default = { };
    };
  };

  imports = [ (import ./_shared.nix { }) ];

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.finalPackage
      cfg.printInitPackage
    ] ++ lib.optional cfg.enableMan self.packages.${pkgs.stdenv.hostPlatform.system}.man-docs;
  };
}
