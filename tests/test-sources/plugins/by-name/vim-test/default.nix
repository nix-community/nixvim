{
  empty = {
    plugins.vim-test.enable = true;
  };

  example = {
    plugins.vim-test = {
      enable = true;

      settings = {
        preserve_screen = false;
        "javascript#jest#options" = "--reporters jest-vim-reporter";
        strategy = {
          nearest = "vimux";
          file = "vimux";
          suite = "vimux";
        };
        "neovim#term_position" = "vert";
      };
    };
  };
}
