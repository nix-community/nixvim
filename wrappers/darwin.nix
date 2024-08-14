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
      darwinConfig = config;
    };
    modules = [
      ./modules/darwin.nix
    ];
  };
in
{
  _file = ./darwin.nix;

  options = {
    programs.nixvim = mkOption {
      inherit (nixvimConfig) type;
      default = { };
    };
  };

  imports = [ (import ./_shared.nix { }) ];

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.build.package
      cfg.build.printInitPackage
    ] ++ lib.optional cfg.enableMan self.packages.${pkgs.stdenv.hostPlatform.system}.man-docs;
  };
}
