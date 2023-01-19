modules:
{ pkgs, config, lib, ... }@args:

let
  inherit (lib) mkEnableOption mkOption mkOptionType mkForce mkMerge mkIf types;
  shared = import ./_shared.nix args;
  cfg = config.programs.nixvim;
in
{
  options = {
    programs.nixvim = mkOption {
      type = types.submodule ((modules pkgs) ++ [{
        options.enable = mkEnableOption "nixvim";
	config.wrapRc = mkForce true;
      }]);
    };
    nixvim.helpers = shared.helpers;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.finalPackage ];
  };
}
