modules:
{ pkgs, config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkMerge mkIf types;
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
      { environment.systemPackages = [ cfg.finalPackage ]; }
      (mkIf (!cfg.wrapRc) {
        environment.etc."nvim/sysinit.vim".text = cfg.initContent;
        environment.variables."VIM" = "/etc/nvim";
      })
    ]);
}
