{
  empty = {
    plugins.indent-blankline.enable = true;
  };

  defaults = {
    plugins.indent-blankline = {
      enable = true;

      char = "│";
      charBlankline = "";
      charList = [];
      charListBlankline = [];
      charHighlightList = [];
      spaceCharBlankline = " ";
      spaceCharHighlightList = [];
      spaceCharBlanklineHighlightList = [];
      useTreesitter = false;
      indentLevel = 10;
      maxIndentIncrease = 10;
      showFirstIndentLevel = true;
      showTrailingBlanklineIndent = true;
      showEndOfLine = false;
      showFoldtext = true;
      disableWithNolist = false;
      filetype = [];
      filetypeExclude = ["lspinfo" "packer" "checkhealth" "help" "man" ""];
      buftypeExclude = ["terminal" "nofile" "quickfix" "prompt"];
      bufnameExclude = [];
      strictTabs = false;
      showCurrentContext = false;
      showCurrentContextStart = false;
      showCurrentContextStartOnCurrentLine = true;
      contextChar = "│";
      contextCharBlankline = "";
      contextCharList = [];
      contextCharListBlankline = [];
      contextHighlightList = [];
      charPriority = 1;
      contextStartPriority = 10000;
      contextPatterns = [
        "class"
        "^func"
        "method"
        "^if"
        "while"
        "for"
        "with"
        "try"
        "except"
        "arguments"
        "argument_list"
        "object"
        "dictionary"
        "element"
        "table"
        "tuple"
        "do_block"
      ];
      useTreesitterScope = false;
      contextPatternHighlight = {};
      viewportBuffer = 10;
      disableWarningMessage = false;
    };
  };
}
