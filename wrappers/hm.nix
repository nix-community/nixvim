modules:
{ pkgs, config, lib, ... }@args:

let
  inherit (lib) mkEnableOption mkOption mkOptionType mkMerge mkIf types;
  shared = import ./_shared.nix args;
  cfg = config.programs.nixvim;
in
{
  options = {
    programs.nixvim = mkOption {
      type = types.submodule ((modules pkgs) ++ [{
        options.enable = mkEnableOption "nixvim";
      }]);
    };
    nixvim.helpers = shared.helpers;
  };

  config = mkIf cfg.enable
    (mkMerge [
      { home.packages = [ cfg.finalPackage ]; }
      (mkIf (!cfg.wrapRc) {
        xdg.configFile."nvim/init.lua".text = cfg.initContent;
      })
      ({
        warnings = cfg.warnings;
      })
    ]);
}
