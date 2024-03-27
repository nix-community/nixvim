{
  empty = {
    plugins.zellij.enable = true;
  };

  defaults = {
    plugins.zellij = {
      enable = true;

      settings = {
        path = "zellij";
        replaceVimWindowNavigationKeybinds = false;
        vimTmuxNavigatorKeybinds = false;
        debug = false;
      };
    };
  };
}
