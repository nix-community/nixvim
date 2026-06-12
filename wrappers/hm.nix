{
  nixvimLib,
  extendModules,
}:
{
  lib,
  config,
  options,
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
      inherit nixvimLib;
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

    programs = mkIf cfg.vimdiffAlias {
      bash.shellAliases.vimdiff = "nvim -d";
      fish.shellAliases.vimdiff = "nvim -d";
      zsh.shellAliases.vimdiff = "nvim -d";
    };

    assertions = [
      {
        assertion = !config.programs.neovim.enable;
        message = "`${options.programs.nixvim}.enable` and `${options.programs.neovim.enable}` are incompatible.";
      }
    ];
  };
}
