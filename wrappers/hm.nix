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
  cfg = config.programs.nixvim;
in
{
  _file = ./hm.nix;

  imports = [
    (import ./_shared.nix {
      inherit self;
      inherit
        (extendModules {
          specialArgs.hmConfig = config;
          modules = [ ./modules/hm.nix ];
        })
        extendModules
        ;
      filesOpt = [
        "xdg"
        "configFile"
      ];
    })
  ];

  config = mkIf cfg.enable {
    home.packages = [
      cfg.build.package
    ];

    home.sessionVariables = mkIf cfg.defaultEditor {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
