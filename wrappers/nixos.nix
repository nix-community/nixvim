modules:
{ pkgs, config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkOptionType mkMerge mkIf types;
  cfg = config.programs.nixvim;
in
{
  options = {
    programs.nixvim = mkOption {
      type = types.submodule ((modules pkgs) ++ [{
        options.enable = mkEnableOption "nixvim";
      }]);
    };
    nixvim.helpers = mkOption {
      type = mkOptionType {
        name = "helpers";
        description = "Helpers that can be used when writing nixvim configs";
        check = builtins.isAttrs;
      };
      description = "Use this option to access the helpers";
      default = import ../plugins/helpers.nix { inherit (pkgs) lib; };
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
