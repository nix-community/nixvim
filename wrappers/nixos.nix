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
  _file = ./nixos.nix;

  imports = [
    (import ./_shared.nix {
      inherit self;
      inherit
        (extendModules {
          specialArgs.nixosConfig = config;
          modules = [ ./modules/nixos.nix ];
        })
        extendModules
        ;
      filesOpt = [
        "environment"
        "etc"
      ];
      initName = "sysinit.lua";
    })
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.build.package
    ];

    environment.variables = {
      VIM = mkIf (!cfg.wrapRc) "/etc/nvim";
      EDITOR = mkIf cfg.defaultEditor (lib.mkOverride 900 "nvim");
      VISUAL = mkIf cfg.defaultEditor (lib.mkOverride 900 "nvim");
    };

    programs.neovim.defaultEditor = cfg.defaultEditor;
  };
}
