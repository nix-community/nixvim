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

      settings = {
        filetypes = {
          help = false;
          gitcommit = false;
          gitrebase = false;
          "." = false;
        };
        manual = false;
        no_map_tab = false;
        idle_delay = 75;
        render = true;
        tab_fallback = "\t";
        disable_bindings = true;
      };
    };
  };
}
