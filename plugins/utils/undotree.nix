{
  lib,
  pkgs,
  ...
} @ args:
with lib;
with (import ../helpers.nix {inherit lib;}).vim-plugin;
  mkVimPlugin args {
    name = "undotree";
    package = pkgs.vimPlugins.undotree;
    globalPrefix = "undotree_";

    options = {
      windowLayout = mkDefaultOpt {
        type = types.int;
        description = ''
          Window layout for undotree.
          Check https://github.com/mbbill/undotree/blob/master/plugin/undotree.vim#L29 for reference
        '';
      };

      shortIndicators = mkDefaultOpt {
        type = types.bool;
        description = ''
          E.g. use 'd' instead of 'days'

          Default: `false`
        '';
      };

      windowWidth = mkDefaultOpt {
        type = types.int;
        description = "Undotree window width";
      };

      diffHeight = mkDefaultOpt {
        type = types.int;
        description = "Undotree diff panel height";
      };

      autoOpenDiff = mkDefaultOpt {
        type = types.bool;
        description = ''
          Auto open diff window

          Default: `true`
        '';
      };

      focusOnToggle = mkDefaultOpt {
        type = types.bool;
        description = ''
          Focus undotree after being opened

          Default: `false`
        '';
      };

      treeNodeShape = mkDefaultOpt {
        type = types.str;
        description = "Tree node shape";
      };

      diffCommand = mkDefaultOpt {
        type = types.str;
        description = "Diff command";
      };

      relativeTimestamp = mkDefaultOpt {
        type = types.bool;
        description = ''
          Use a relative timestamp.

          Default: `true`
        '';
      };

      highlightChangedText = mkDefaultOpt {
        type = types.bool;
        description = ''
          Highlight changed text

          Default: `true`
        '';
      };

      highlightChangesWithSign = mkDefaultOpt {
        type = types.bool;
        description = ''
          Highlight changes with a sign in the gutter

          Default: `true`
        '';
      };

      highlightSyntaxAdd = mkDefaultOpt {
        type = types.str;
        description = "Added lines highlight group";
      };

      highlightSyntaxChange = mkDefaultOpt {
        type = types.str;
        description = "Changed lines highlight group";
      };

      highlightSyntaxDel = mkDefaultOpt {
        type = types.str;
        description = "Deleted lines highlight group";
      };

      showHelpLine = mkDefaultOpt {
        type = types.bool;
        description = ''
          Show help line.

          Default: `true`
        '';
      };

      showCursorLine = mkDefaultOpt {
        type = types.bool;
        description = ''
          Show cursor line

          Default: `true`
        '';
      };
    };
  }
