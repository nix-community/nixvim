{
  empty = {
    plugins.vim-be-better.enable = true;
  };

  default = {
    plugins.vim-be-better = {
      enable = true;
      settings = {
        log_file = true;
        default_difficulty = "medium";
      };
    };
  };
}
