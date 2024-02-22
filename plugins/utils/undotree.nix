{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib;
with helpers.vim-plugin;
  mkVimPlugin config {
    name = "undotree";
    defaultPackage = pkgs.vimPlugins.undotree;
    globalPrefix = "undotree_";
    deprecateExtraConfig = true;

    # TODO introduced 2024-02-22: remove 2024-04-22
    imports = let
      basePluginPath = ["plugins" "undotree"];
    in
      mapAttrsToList
      (
        old: new:
          mkRenamedOptionModule
          (basePluginPath ++ [old])
          (basePluginPath ++ ["settings" new])
      )
      {
        windowLayout = "WindowLayout";
        shortIndicators = "ShortIndicators";
        windowWidth = "WindowWidth";
        diffHeight = "DiffHeight";
        autoOpenDiff = "AutoOpenDiff";
        focusOnToggle = "FocusOnToggle";
        treeNodeShape = "TreeNodeShape";
        diffCommand = "DiffCommand";
        relativeTimestamp = "RelativeTimestamp";
        highlightChangedText = "HighlightChangedText";
        highlightChangesWithSign = "HighlightChangesWithSign";
        highlightSyntaxAdd = "HighlightSyntaxAdd";
        highlightSyntaxChange = "HighlightSyntaxChange";
        highlightSyntaxDel = "HighlightSyntaxDel";
        showHelpLine = "ShowHelpLine";
        showCursorLine = "ShowCursorLine";
      };

    settingsExample = {
      WindowLayout = 4;
      ShortIndicators = false;
      DiffpanelHeight = 10;
      DiffAutoOpen = true;
      SetFocusWhenToggle = true;
      SplitWidth = 40;
      TreeNodeShape = "*";
      TreeVertShape = "|";
      TreeSplitShape = "/";
      TreeReturnShape = "\\";
      DiffCommand = "diff";
      RelativeTimestamp = true;
      HighlightChangedText = true;
      HighlightChangedWithSign = true;
      HighlightSyntaxAdd = "DiffAdd";
      HighlightSyntaxChange = "DiffChange";
      HighlightSyntaxDel = "DiffDelete";
      HelpLine = true;
      CursorLine = true;
    };
  }
