self:
{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  inherit (lib.modules)
    importApply
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

  imports = [ (importApply ./_shared.nix { inherit self evalArgs; }) ];

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.build.package
    ];
  };
}
