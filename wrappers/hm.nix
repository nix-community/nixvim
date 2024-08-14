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
    mkMerge
    mkIf
    types
    ;
  cfg = config.programs.nixvim;
  nixvimConfig = config.lib.nixvim.modules.evalNixvim {
    extraSpecialArgs = {
      hmConfig = config;
    };
    modules = [
      ./modules/hm.nix
    ];
  };
in
{
  _file = ./hm.nix;

  options = {
    programs.nixvim = mkOption {
      inherit (nixvimConfig) type;
      default = { };
    };
  };

  imports = [
    (import ./_shared.nix {
      filesOpt = [
        "xdg"
        "configFile"
      ];
    })
  ];

  config = mkIf cfg.enable {
    home.packages = [
      cfg.build.package
      cfg.build.printInitPackage
    ] ++ lib.optional cfg.enableMan self.packages.${pkgs.stdenv.hostPlatform.system}.man-docs;

    home.sessionVariables = mkIf cfg.defaultEditor { EDITOR = "nvim"; };

    programs = mkIf cfg.vimdiffAlias {
      bash.shellAliases.vimdiff = "nvim -d";
      fish.shellAliases.vimdiff = "nvim -d";
      zsh.shellAliases.vimdiff = "nvim -d";
    };
  };
}
