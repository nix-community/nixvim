{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.null-ls;
  helpers = (import ../helpers.nix { inherit lib; });
in
{
  imports = [
    ./servers.nix
  ];

  options.programs.nixvim.plugins.null-ls = {
    enable = mkEnableOption "Enable null-ls";

    debug = mkOption {
      default = null;
      type = with types; nullOr bool;
    };

    sourcesItems = mkOption {
      default = null;
      # type = with types; nullOr (either (listOf str) (listOf attrsOf str));
      type = with types; nullOr (listOf (attrsOf str));
      description = "The list of sources to enable, should be strings of lua code. Don't use this directly";
    };

    # sources = mkOption {
    #   default = null;
    #   type = with types; nullOr attrs;
    # };
  };

  config = let
    options = {
      debug = cfg.debug;
      sources = cfg.sourcesItems;
    };
  in mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [ null-ls-nvim ];

      extraConfigLua = ''
        require("null-ls").setup(${helpers.toLuaObject options})
      '';
    };
  };
}
