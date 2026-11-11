{
  empty = {
    plugins.phpactor.enable = true;
  };

  example = { pkgs, ... }: {
    extraPlugins = [ pkgs.vimPlugins.fzf-wrapper ];

    plugins.phpactor = {
      enable = true;
      settings = {
        Branch = "main";
        InputListStrategy = "phpactor#input#list#fzf";
        OmniAutoClassImport = true;
        CompletionIgnoreCase = false;
      };
    };
  };
}
