{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "undotree";
  globalPrefix = "undotree_";
  description = "The undo history visualizer for Vim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

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
