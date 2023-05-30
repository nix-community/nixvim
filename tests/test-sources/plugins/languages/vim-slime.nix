{
  empty = {
    plugins.vim-slime.enable = true;
  };

  example = {
    plugins.vim-slime = {
      enable = true;

      target = "screen";
      vimterminalCmd = null;
      noMappings = false;
      pasteFile = "$HOME/.slime_paste";
      preserveCurpos = true;
      defaultConfig = {
        socket_name = "default";
        target_pane = "{last}";
      };
      dontAskDefault = false;
      bracketedPaste = false;
    };
  };
}
