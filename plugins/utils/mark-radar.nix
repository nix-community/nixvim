{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.plugins.mark-radar;
  helpers = import ../helpers.nix { inherit lib; };
  defs = import ../plugin-defs.nix { inherit pkgs; };
in
{
  options.plugins.mark-radar = {
    enable = mkEnableOption "Enable mark-radar";

    package = mkOption {
      type = types.package;
      default = defs.mark-radar;
      description = "Plugin to use for mark-radar";
    };

    highlight_background = mkOption {
      type = with types; nullOr bool;
      default = null;
    };

    background_highlight_group = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    highlight_group = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    set_default_keybinds = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };

  config =
    let
      opts = helpers.toLuaObject {
        inherit (cfg) highlight_group background_highlight_group;
        set_default_mappings = cfg.set_default_keybinds;
        background_highlight = cfg.highlight_background;
      };
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require("mark-radar").setup(${opts})
      '';
    };
}
