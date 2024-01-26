{
  empty = {
    plugins.haskell-scope-highlighting.enable = true;
    plugins.treesitter.enable = true;
  };

  testHaskellHighlights = {
    plugins.haskell-scope-highlighting.enable = true;
    plugins.treesitter.enable = true;
    highlight = {
      HaskellCurrentScope.bg = "black";
      HaskellParentScope1.bg = "black";
      HaskellParentScope2.bg = "black";
      HaskellParentScope3.bg = "black";
      HaskellVariableDeclarationWithinScope.bg = "black";
      HaskellVariableDeclaredWithinFile.bg = "black";
      HaskellVariableDeclaredWithinParent1.bg = "black";
      HaskellVariableDeclaredWithinParent2.bg = "black";
      HaskellVariableDeclaredWithinParent3.bg = "black";
      HaskellVariableDeclaredWithinScope.bg = "black";
      HaskellVariableNotDeclaredWithinFile.bg = "black";
    };
  };
}
