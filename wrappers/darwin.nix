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
  evalArgs = {
    extraSpecialArgs = {
      darwinConfig = config;
    };
    modules = [
      ./modules/darwin.nix
    ];
  };
in
{
  _file = ./darwin.nix;

  imports = [ (import ./_shared.nix { inherit evalArgs; }) ];

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.build.package
      cfg.build.printInitPackage
    ] ++ lib.optional cfg.enableMan self.packages.${pkgs.stdenv.hostPlatform.system}.man-docs;
  };
}
