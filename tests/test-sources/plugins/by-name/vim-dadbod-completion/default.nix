{
  empty = {
    plugins.vim-dadbod-completion.enable = true;
    plugins.vim-dadbod-completion.cmp.enable = false;
  };

  with-cmp = {
    plugins.cmp.enable = true;
    plugins.vim-dadbod-completion.enable = true;
  };
}
