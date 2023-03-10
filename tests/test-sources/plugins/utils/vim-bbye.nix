{
  empty = {
    plugins.vim-bbye.enable = true;
  };

  test = {
    plugins.vim-bbye = {
      enable = true;

      keymapsSilent = false;

      keymaps = {
        bdelete = "<C-w>";
        bwipeout = "<C-t>";
      };
    };
  };
}
