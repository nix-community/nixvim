{
  lib,
  helpers,
  ...
}:
with lib;
with lib.nixvim.vim-plugin;
mkVimPlugin {
  name = "undotree";
  globalPrefix = "undotree_";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-02-22: remove 2024-04-22
  deprecateExtraConfig = true;
  imports =
    let
      basePluginPath = [
        "plugins"
        "undotree"
      ];
    in
    mapAttrsToList
      (
        old: new:
        mkRenamedOptionModule (basePluginPath ++ [ old ]) (
          basePluginPath
          ++ [
            "settings"
            new
          ]
        )
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
