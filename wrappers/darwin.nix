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

  imports = [ (import ./_shared.nix { inherit self evalArgs; }) ];

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.build.package
      cfg.build.printInitPackage
    ] ++ lib.optional cfg.enableMan cfg.build.manDocsPackage;
  };
}
