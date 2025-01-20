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
      nixosConfig = config;
    };
    modules = [
      ./modules/nixos.nix
    ];
  };
in
{
  _file = ./nixos.nix;

  imports = [
    (import ./_shared.nix {
      inherit self evalArgs;
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
    };

    programs.neovim.defaultEditor = cfg.defaultEditor;
  };
}
