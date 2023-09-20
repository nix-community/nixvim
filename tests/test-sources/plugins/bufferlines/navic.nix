{
  empty = {
    plugins.navic.enable = true;
  };

  defaults = {
    plugins.navic = {
      enable = true;
      lsp = {
        autoAttach = true;
      };
      separator = " | ";
      click = true;
    };
  };
}
