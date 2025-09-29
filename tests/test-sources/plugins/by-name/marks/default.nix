{
  empty = {
    plugins.marks.enable = true;
  };

  example = {
    plugins.marks = {
      enable = true;
      settings = {
        cyclic = true;
        refreshInterval = 150;
        mappings = {
          set = "<Leader>mM";
          delete = "<Leader>md";
          next = "<Leader>mn";
          prev = "<Leader>mp";
          toggle = "<Leader>mm";
          delete_buf = "<Leader>mc";
          delete_line = "<Leader>mD";
        };
      };
    };
  };

  defaults = {
    plugins.marks = {
      enable = true;
      settings = {
        default_mappings = true;
        builtin_marks.__empty = { };
        cyclic = true;
        force_write_shada = false;
        refresh_interval = 150;
        sign_priority = 10;
        excluded_filetypes.__empty = { };
        excluded_buftypes.__empty = { };
        mappings = {
          set = "m";
          set_next = "m;";
          toggle = "m;";
          next = "m]";
          prev = "m[";
          preview = "m:";
          next_bookmark = "m}";
          prev_bookmark = "m{";
          delete = "dm";
          delete_line = "dm-";
          delete_bookmark = "dm=";
          delete_buf = "dm<space>";
        };
      };
    };
  };
}
