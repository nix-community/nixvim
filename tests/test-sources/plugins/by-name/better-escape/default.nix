{
  empty = {
    plugins.better-escape.enable = true;
  };

  defaults = {

    plugins.better-escape = {
      enable = true;

      settings = {
        timeout = "vim.o.timeoutlen";
        default_mappings = true;
        mappings = {
          i.j = {
            k = "<Esc>";
            j = "<Esc>";
          };
          c.j = {
            k = "<Esc>";
            j = "<Esc>";
          };
          t.j = {
            k = "<Esc>";
            j = "<Esc>";
          };
          v.j.k = "<Esc>";
          s.j.k = "<Esc>";
        };
      };
    };
  };

  example = {
    plugins.better-escape = {
      enable = true;

      settings = {
        mappings.i.j = {
          k = "<Esc>";
          j = "<Esc>";
        };
        timeout = 150;
      };
    };
  };
}
