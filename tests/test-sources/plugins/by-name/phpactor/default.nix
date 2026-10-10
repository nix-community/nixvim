{
  empty = {
    plugins.phpactor.enable = true;
  };

  example = {
    plugins.phpactor = {
      enable = true;
      settings = {
        Branch = "main";
        InitialCwd = true;
        InputListStrategy = "phpactor#input#list#fzf";
        OmniAutoClassImport = true;
        CompletionIgnoreCase = false;
      };
    };
  };
}
