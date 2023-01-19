{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.plugins.null-ls;
  helpers = (import ../helpers.nix { inherit lib; });
in
{
  imports = [
    ./servers.nix
  ];

  options.plugins.null-ls = {
    enable = mkEnableOption "Enable null-ls";

    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.null-ls-nvim;
      description = "Plugin to use for null-ls";
    };

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

  config =
    let
      options = {
        debug = cfg.debug;
        sources = cfg.sourcesItems;
      };
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require("null-ls").setup(${helpers.toLuaObject options})
      '';
    };
}
