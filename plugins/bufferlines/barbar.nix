{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.plugins.barbar;
in
{
  options.plugins.barbar = {
    enable = mkEnableOption "Enable barbar.nvim";

    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.barbar-nvim;
      description = "Plugin to use for barbar";
    };

    animations = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "Enable animations";
    };

    autoHide = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "Auto-hide the tab bar when there is only one buffer";
    };

    closeable = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "Enable the close button";
    };

    icons = mkOption {
      type = with types; nullOr (oneOf [bool (enum ["numbers both"])]);
      default = null;
      description = "Enable/disable icons";
    };

    iconCustomColors = mkOption {
      type = with types; nullOr (oneOf [bool str]);
      default = null;
      description = "Sets the icon highlight group";
    };

    # Keybinds concept:
    # keys = {
    #   previousBuffer = mkBindDef "normal" "Previous buffer" { action = ":BufferPrevious<CR>"; silent = true; } "<A-,>";
    #   nextBuffer = mkBindDef "normal" "Next buffer" { action = ":BufferNext<CR>"; silent = true; } "<A-.>";
    #   movePrevious = mkBindDef "normal" "Re-order to previous" { action = ":BufferMovePrevious<CR>"; silent = true; } "<A-<>";
    #   moveNext = mkBindDef "normal" "Re-order to next" { action = ":BufferMoveNext<CR>"; silent = true; } "<A->>";

    #   # TODO all the other ones.....
    # };
  };

  config = mkIf cfg.enable {
    extraPlugins = with pkgs.vimPlugins; [
      cfg.package nvim-web-devicons
    ];

    # maps = genMaps cfg.keys;
  };
}
