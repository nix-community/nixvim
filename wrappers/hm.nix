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
          # TODO: maybe don't do this by default?
          { nixpkgs.pkgs = pkgs; }
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
