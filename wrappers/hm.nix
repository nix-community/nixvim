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
in
{
  options = {
    programs.nixvim = mkOption {
      default = { };
      type = types.submoduleWith {
        shorthandOnlyDefinesConfig = true;
        specialArgs = config.lib.nixvim.modules.specialArgsWith {
          defaultPkgs = pkgs;
          hmConfig = config;
        };
        modules = [
          ./modules/hm.nix
          ../modules/top-level
        ];
      };
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
      cfg.finalPackage
      cfg.printInitPackage
    ] ++ lib.optional cfg.enableMan self.packages.${pkgs.stdenv.hostPlatform.system}.man-docs;

    home.sessionVariables = mkIf cfg.defaultEditor { EDITOR = "nvim"; };

    programs = mkIf cfg.vimdiffAlias {
      bash.shellAliases.vimdiff = "nvim -d";
      fish.shellAliases.vimdiff = "nvim -d";
      zsh.shellAliases.vimdiff = "nvim -d";
    };
  };
}
