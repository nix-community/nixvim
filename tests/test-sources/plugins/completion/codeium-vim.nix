{
  empty = {
    plugins.codeium-vim.enable = true;
  };

  example = {
    plugins.codeium-vim = {
      enable = true;

      keymaps = {
        clear = "<C-]>";
        next = "<M-]>";
        prev = "<M-[>";
        accept = "<Tab>";
        complete = "<M-Bslash>";
      };
      filetypes = {
        help = false;
        gitcommit = false;
        gitrebase = false;
        "." = false;
      };
      manual = false;
      noMapTab = false;
      idleDelay = 75;
      render = true;
      tabFallback = "\t";
      disableBindings = true;
    };
  };
}
