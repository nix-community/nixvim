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
      inherit evalArgs;
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
      cfg.build.printInitPackage
    ] ++ lib.optional cfg.enableMan self.packages.${pkgs.stdenv.hostPlatform.system}.man-docs;

    environment.variables = {
      VIM = mkIf (!cfg.wrapRc) "/etc/nvim";
      EDITOR = mkIf cfg.defaultEditor (lib.mkOverride 900 "nvim");
    };

    programs.neovim.defaultEditor = cfg.defaultEditor;
  };
}
