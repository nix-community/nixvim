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
in
{
  options = {
    programs.nixvim = mkOption {
      default = { };
      type = types.submoduleWith {
        shorthandOnlyDefinesConfig = true;
        specialArgs = config.lib.nixvim.modules.specialArgsWith {
          defaultPkgs = pkgs;
          nixosConfig = config;
        };
        modules = [
          ./modules/nixos.nix
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
        "environment"
        "etc"
      ];
      initName = "sysinit.lua";
    })
  ];

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [
        cfg.finalPackage
        cfg.printInitPackage
      ] ++ (lib.optional cfg.enableMan self.packages.${pkgs.stdenv.hostPlatform.system}.man-docs);
    }
    {
      inherit (cfg) warnings assertions;
      programs.neovim.defaultEditor = cfg.defaultEditor;
      environment.variables = {
        VIM = mkIf (!cfg.wrapRc) "/etc/nvim";
        EDITOR = mkIf cfg.defaultEditor (lib.mkOverride 900 "nvim");
      };
    }
  ]);
}
