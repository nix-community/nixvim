{pkgs}: {
  empty = {
    plugins.treesitter.enable = true;
    plugins.treesitter-playground.enable = true;
  };

  default = {
    plugins.treesitter.enable = true;
    plugins.treesitter-playground = {
      enable = true;

      disabledLanguages = [];
      updateTime = 25;
      persistQueries = false;
      keybindings = {
        toggleQueryEditor = "o";
        toggleHlGroups = "i";
        toggleInjectedLanguages = "t";
        toggleAnonymousNodes = "a";
        toggleLanguageDisplay = "I";
        focusLanguage = "f";
        unfocusLanguage = "F";
        update = "R";
        gotoNode = "<cr>";
        showHelp = "?";
      };
    };
  };
}
