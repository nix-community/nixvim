{
  self,
  extendModules,
}:
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
in
{
  _file = ./darwin.nix;

  imports = [
    (importApply ./_shared.nix {
      inherit self;
      inherit
        (extendModules {
          specialArgs.darwinConfig = config;
          modules = [ ./modules/darwin.nix ];
        })
        extendModules
        ;
    })
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.build.package
    ];
  };
}
