modules:
{ pkgs, config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types;
  cfg = config.programs.nixvim;
in {
  options = {
    programs.nixvim = lib.mkOption {
      type = types.submodule ((modules pkgs) ++ [{
        options.enable = mkEnableOption "nixvim";
      }]);
    };
  };

  config = mkIf cfg.enable 
    (mkMerge [
      { home.packages = [ cfg.finalPackage ]; }
      (mkIf (!cfg.wrapRc) {
        xdg.configFile."nvim/init.vim".text = cfg.initContent;
      })
    ]);
}
