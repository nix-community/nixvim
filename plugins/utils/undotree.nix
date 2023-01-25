{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.undotree;
  helpers = import ../helpers.nix { inherit lib; };
in
{
  options = {
    plugins.undotree = {
      enable = mkEnableOption "Enable undotree";

      package = mkOption {
        type = types.package;
        default = pkgs.vimPlugins.undotree;
        description = "Plugin to use for undotree";
      };

      windowLayout = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Window layout for undotree. Check https://github.com/mbbill/undotree/blob/master/plugin/undotree.vim#L29 for reference";
      };

      shortIndicators = mkOption {
        type = types.bool;
        default = false;
        description = "E.g. use 'd' instead of 'days'";
      };

      windowWidth = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Undotree window width";
      };

      diffHeight = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Undotree diff panel height";
      };

      autoOpenDiff = mkOption {
        type = types.bool;
        default = true;
        description = "Auto open diff window";
      };

      focusOnToggle = mkOption {
        type = types.bool;
        default = false;
        description = "Focus undotree after being opened";
      };

      treeNodeShape = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Tree node shape";
      };

      diffCommand = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Diff command";
      };

      relativeTimestamp = mkOption {
        type = types.bool;
        default = true;
        description = "Use a relative timestamp";
      };

      highlightChangedText = mkOption {
        type = types.bool;
        default = true;
        description = "Highlight changed text";
      };

      highlightChangesWithSign = mkOption {
        type = types.bool;
        default = true;
        description = "Highlight changes with a sign in the gutter";
      };

      highlightSyntaxAdd = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Added lines highlight group";
      };

      highlightSyntaxChange = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Changed lines highlight group";
      };

      highlightSyntaxDel = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Deleted lines highlight group";
      };

      showHelpLine = mkOption {
        type = types.bool;
        default = true;
        description = "Show help line";
      };

      showCursorLine = mkOption {
        type = types.bool;
        default = true;
        description = "Show cursor line";
      };
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    globals = {
      undotree_WindowLayout = mkIf (cfg.windowLayout != null) cfg.windowLayout;
      undotree_ShortIndicators = mkIf cfg.shortIndicators 1;
      undotree_SplitWidth = mkIf (cfg.windowWidth != null) cfg.windowWidth;
      undotree_DiffpanelHeight = mkIf (cfg.diffHeight != null) cfg.diffHeight;
      undotree_DiffAutoOpen = mkIf (!cfg.autoOpenDiff) 0;
      undotree_SetFocusWhenToggle = mkIf cfg.focusOnToggle 1;
      undotree_TreeNodeShape = mkIf (cfg.treeNodeShape != null) cfg.treeNodeShape;
      undotree_DiffCommand = mkIf (cfg.diffCommand != null) cfg.diffCommand;
      undotree_RelativeTimestamp = mkIf (!cfg.relativeTimestamp) 0;
      undotree_HighlightChangedText = mkIf (!cfg.highlightChangedText) 0;
      undotree_HighlightChangedWithSign = mkIf (!cfg.highlightChangesWithSign) 0;
      undotree_HighlightSyntaxAdd = mkIf (cfg.highlightSyntaxAdd != null) cfg.highlightSyntaxAdd;
      undotree_HighlightSyntaxChange = mkIf (cfg.highlightSyntaxChange != null) cfg.highlightSyntaxAdd;
      undotree_HighlightSyntaxDel = mkIf (cfg.highlightSyntaxDel != null) cfg.highlightSyntaxDel;
      undotree_HelpLine = mkIf (!cfg.showHelpLine) 0;
      undotree_CursorLine = mkIf (!cfg.showCursorLine) 0;
    };
  };
}
