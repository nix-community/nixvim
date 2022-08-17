{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.barbar;
  helpers = import ../helpers.nix { inherit lib config; };
in with helpers;
{
  options.programs.nixvim.plugins.barbar = {
    enable = mkEnableOption "Enable barbar.nvim";

    animation = boolOption true "Enable animations";
    autoHide = boolOption false "Auto-hide the tab bar when there is only one buffer";
    tabpages = boolOption true "Enable 'current/total' tabpages indicator in top right corner";
    closable = boolOption true "Enable the close button";
    clickable = boolOption true "Enable clickable tabs\n - left-click: go to buffer\n - middle-click: delete buffer";

    extraConfig = mkOption {
      type = types.attrs;
      default = {};
      description = "Place any extra config here as attibute-set";
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

  config.programs.nixvim = let
    pluginConfig = {
      animation = cfg.animation;
      closable = cfg.closable;
    } // cfg.extraConfig;
  in mkIf cfg.enable {
    extraPlugins = with pkgs.vimExtraPlugins; [
      barbar-nvim
      nvim-web-devicons
    ];

    extraConfigLua = ''
      require("bufferline").setup(${helpers.toLuaObject pluginConfig})
    '';
  };
}
