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
        type = types.str;
        default = "&shell";
      };
      title = mkOption {
        type = types.str;
        description = "Show floaterm info at the top left corner of the floaterm window.";
        default = "floaterm: $1/$2";
      };
      winType = mkOption {
        type = types.enum [ "float" "split" "vsplit" ];
        default = "float";
      };
      winWidth = mkOption {
        type = types.float;
        description = "number of columns relative to &columns.";
        default = 0.6;
      };
      winHeight = mkOption {
        type = types.float;
        description = "number of lines relative to &lines.";
        default = 0.6;
      };
      borderChars = mkOption {
        type = types.str;
        description = "8 characters of the floating window border (top, right, bottom, left, topleft, topright, botright, botleft)";
        default = "─│─│┌┐┘└";
      };
      rootMarkers = mkOption {
        type = types.listOf types.str;
        description = "Markers used to detect the project root directory for --cwd=<root>";
        default = [ ".project" ".git" ".hg" ".svn" ".root" ];
      };
      opener = mkOption {
        type = types.enum [ "edit" "split" "vsplit" "tabe" "drop" ];
        description = "Command used for opening a file in the outside nvim from within :terminal";
        default = "split";
      };
      autoClose = mkOption {
        type = types.enum [ 0 1 2 ];
        description = "Whether to close floaterm window once the job gets finished.";
        default = 0;
      };
      autoHide = mkOption {
        type = types.enum [ 0 1 2 ];
        description = "Whether to hide previous floaterm before switching to or opening another one.";
        default = 1;
      };
      autoInsert = mkOption {
        type = types.bool;
        description = "Whether to enter Terminal-mode after opening a floaterm.";
        default = true;
      };
    };
  };
  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [
        vim-floaterm
      ];
      globals = {
        floaterm_shell = cfg.shell;
        floaterm_title = cfg.title;
        floaterm_wintype = cfg.winType;
        floaterm_width = cfg.winWidth;
        floaterm_height = cfg.winHeight;
        floaterm_borderchars = cfg.borderChars;
        floaterm_rootmarkers = cfg.rootMarkers;
        floaterm_opener = cfg.opener;
        floaterm_autoclose = cfg.autoClose;
        floaterm_autohide = cfg.autoHide;
        floaterm_autoInsert = cfg.autoInsert;
      };
    };
  };
}
