{
  lib,
  helpers,
  ...
}:
with lib;
with lib.nixvim.plugins;
mkVimPlugin {
  name = "undotree";
  globalPrefix = "undotree_";
  description = "The undo history visualizer for Vim.";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-02-22: remove 2024-04-22
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    {
      old = "windowLayout";
      new = "WindowLayout";
    }
    {
      old = "shortIndicators";
      new = "ShortIndicators";
    }
    {
      old = "windowWidth";
      new = "WindowWidth";
    }
    {
      old = "diffHeight";
      new = "DiffHeight";
    }
    {
      old = "autoOpenDiff";
      new = "AutoOpenDiff";
    }
    {
      old = "focusOnToggle";
      new = "FocusOnToggle";
    }
    {
      old = "treeNodeShape";
      new = "TreeNodeShape";
    }
    {
      old = "diffCommand";
      new = "DiffCommand";
    }
    {
      old = "relativeTimestamp";
      new = "RelativeTimestamp";
    }
    {
      old = "highlightChangedText";
      new = "HighlightChangedText";
    }
    {
      old = "highlightChangesWithSign";
      new = "HighlightChangesWithSign";
    }
    {
      old = "highlightSyntaxAdd";
      new = "HighlightSyntaxAdd";
    }
    {
      old = "highlightSyntaxChange";
      new = "HighlightSyntaxChange";
    }
    {
      old = "highlightSyntaxDel";
      new = "HighlightSyntaxDel";
    }
    {
      old = "showHelpLine";
      new = "ShowHelpLine";
    }
    {
      old = "showCursorLine";
      new = "ShowCursorLine";
    }
  ];

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
