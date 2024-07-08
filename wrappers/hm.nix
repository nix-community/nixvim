{ self, getHelpers }:
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
  helpers = getHelpers pkgs false;
  cfg = config.programs.nixvim;
in
{
  options = {
    programs.nixvim = mkOption {
      default = { };
      type = types.submoduleWith {
        shorthandOnlyDefinesConfig = true;
        specialArgs = {
          hmConfig = config;
          defaultPkgs = pkgs;
          inherit helpers;
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
      inherit helpers;
      filesOpt = [
        "xdg"
        "configFile"
      ];
    })
  ];

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [
        cfg.finalPackage
        cfg.printInitPackage
      ] ++ (lib.optional cfg.enableMan self.packages.${pkgs.stdenv.hostPlatform.system}.man-docs);
    }
    {
      inherit (cfg) warnings assertions;
      home.sessionVariables = mkIf cfg.defaultEditor { EDITOR = "nvim"; };
    }
    {
      programs.bash.shellAliases = mkIf cfg.vimdiffAlias { vimdiff = "nvim -d"; };
      programs.fish.shellAliases = mkIf cfg.vimdiffAlias { vimdiff = "nvim -d"; };
      programs.zsh.shellAliases = mkIf cfg.vimdiffAlias { vimdiff = "nvim -d"; };
    }
  ]);
}
