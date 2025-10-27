{
  empty = {
    plugins.lir.enable = true;
  };

  defaults = {
    plugins.lir = {
      enable = true;

      settings = {
        show_hidden_files = false;
        ignore.__empty = { };
        devicons = {
          enable = false;
          highlight_dirname = false;
        };
        hide_cursor = false;
        on_init.__raw = "function() end";
        mappings.__empty = { };
        float = {
          winblend = 0;
          curdir_window = {
            enable = false;
            highlight_dirname = false;
          };
        };
        get_filters.__raw = "nil";
      };
    };
  };

  example = {
    plugins.lir = {
      enable = true;

      settings = {
        show_hidden_files = true;
        devicons.enable = false;
        mappings = {
          "<CR>".__raw = "require'lir.actions'.edit";
          "-".__raw = "require'lir.actions'.up";
          "<ESC>".__raw = "require'lir.actions'.quit";
          "@".__raw = "require'lir.actions'.cd";
        };
        hide_cursor = true;
      };
    };
  };
}
