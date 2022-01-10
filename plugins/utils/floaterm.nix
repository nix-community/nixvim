{ config, pkgs, lib, ... }:
with lib;
let 
  cfg = config.programs.nixvim.plugins.floaterm;
  helpers = import ../helpers.nix { inherit lib; };
in
{
  options = {
    programs.nixvim.plugins.floaterm = {
      enable = mkEnableOption "Enable floaterm";
      shell = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      title = mkOption {
        type = types.nullOr types.str;
        description = "Show floaterm info at the top left corner of the floaterm window.";
        default = null;
      };
      winType = mkOption {
        type = types.nullOr (types.enum [ "float" "split" "vsplit" ]);
        default = null;
      };
      winWidth = mkOption {
        type = types.nullOr types.float;
        description = "number of columns relative to &amp;columns.";
        default = null;
      };
      winHeight = mkOption {
        type = types.nullOr types.float;
        description = "number of lines relative to &amp;lines.";
        default = null;
      };
      borderChars = mkOption {
        type = types.nullOr types.str;
        description = "8 characters of the floating window border (top, right, bottom, left, topleft, topright, botright, botleft)";
        default = null;
      };
      rootMarkers = mkOption {
        type = types.nullOr (types.listOf types.str);
        description = "Markers used to detect the project root directory for --cwd=&lt;root&gt;";
        default = null;
      };
      opener = mkOption {
        type = types.nullOr (types.enum [ "edit" "split" "vsplit" "tabe" "drop" ]);
        description = "Command used for opening a file in the outside nvim from within :terminal";
        default = null;
      };
      autoClose = mkOption {
        type = types.nullOr (types.enum [ 0 1 2 ]);
        description = "Whether to close floaterm window once the job gets finished.";
        default = null;
      };
      autoHide = mkOption {
        type = types.nullOr (types.enum [ 0 1 2 ]);
        description = "Whether to hide previous floaterm before switching to or opening another one.";
        default = null;
      };
      autoInsert = mkOption {
        type = types.nullOr types.bool;
        description = "Whether to enter Terminal-mode after opening a floaterm.";
        default = null;
      };
    };
  };
  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [
        vim-floaterm
      ];
      globals = {
        floaterm_shell = mkIf (!isNull cfg.shell) cfg.shell;
        floaterm_title = mkIf (!isNull cfg.title) cfg.title;
        floaterm_wintype = mkIf (!isNull cfg.winType) cfg.winType;
        floaterm_width = mkIf (!isNull cfg.winWidth) cfg.winWidth;
        floaterm_height = mkIf (!isNull cfg.winHeight) cfg.winHeight;
        floaterm_borderchars = mkIf (!isNull cfg.borderChars) cfg.borderChars;
        floaterm_rootmarkers = mkIf (!isNull cfg.rootMarkers) cfg.rootMarkers;
        floaterm_opener = mkIf (!isNull cfg.opener) cfg.opener;
        floaterm_autoclose = mkIf (!isNull cfg.autoClose) cfg.autoClose;
        floaterm_autohide = mkIf (!isNull cfg.autoHide) cfg.autoHide;
        floaterm_autoInsert = mkIf (!isNull cfg.autoInsert) cfg.autoInsert;
      };
    };
  };
}
