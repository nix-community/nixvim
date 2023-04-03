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

  # This needs a custom input
  # custom = {
  #   plugins.treesitter = {
  #     enable = true;
  #     nixGrammars = true;
  #     grammarPackages = [
  #       (build-ts.lib.buildGrammar pkgs {
  #         language = "gleam";
  #         version = "0.25.0";
  #         source = gleam;
  #       })
  #     ];
  #   };
  # };
}
