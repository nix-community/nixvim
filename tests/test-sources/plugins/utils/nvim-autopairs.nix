{
  empty = {
    plugins.nvim-autopairs.enable = true;
  };

  defaults = {
    plugins.nvim-autopairs = {
      enable = true;

      pairs = null;
      disabledFiletypes = ["TelescopePrompt" "spectre_panel"];
      disableInMacro = false;
      disableInVisualblock = false;
      disableInReplaceMode = true;
      ignoredNextChar = "[=[[%w%%%'%[%\"%.%`%$]]=]";
      enableMoveright = true;
      enableAfterQuote = true;
      enableCheckBracketLine = true;
      enableBracketInQuote = true;
      enableAbbr = false;
      breakUndo = true;
      checkTs = false;
      tsConfig = {
        lua = ["string" "source"];
        javascript = ["string" "template_string"];
      };
      mapCr = true;
      mapBs = true;
      mapCH = false;
      mapCW = false;
    };
  };
}
