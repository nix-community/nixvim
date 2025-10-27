{
  empty = {
    plugins.transparent.enable = true;
  };

  defaults = {
    plugins.transparent = {
      enable = true;

      settings = {
        groups = [
          "Normal"
          "NormalNC"
          "Comment"
          "Constant"
          "Special"
          "Identifier"
          "Statement"
          "PreProc"
          "Type"
          "Underlined"
          "Todo"
          "String"
          "Function"
          "Conditional"
          "Repeat"
          "Operator"
          "Structure"
          "LineNr"
          "NonText"
          "SignColumn"
          "CursorLine"
          "CursorLineNr"
          "StatusLine"
          "StatusLineNC"
          "EndOfBuffer"
        ];
        extra_groups.__empty = { };
        exclude_groups.__empty = { };
      };
    };
  };
}
