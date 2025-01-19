{
  empty = {
    plugins.vim-suda.enable = true;
  };

  defaults = {
    plugins.vim-suda = {
      enable = true;
      settings = {
        path = "sudo";
        noninteractive = 0;
        prompt = "Password: ";
        smart_edit = 0;
      };
    };
  };

  example = {
    plugins.vim-suda = {
      enable = true;
      settings = {
        path = "doas";
        noninteractive = 1;
        prompt = "Pass: ";
        smart_edit = 1;
      };
    };
  };
}
