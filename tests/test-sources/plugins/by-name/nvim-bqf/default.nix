{
  empty = {
    plugins.nvim-bqf.enable = true;
  };

  example = {
    plugins.nvim-bqf = {
      enable = true;
      settings = {
        preview = {
          winblend = 0;
          show_title = false;
          border = "double";
          show_scroll_bar = false;
        };
      };
    };
  };

  defaults = {
    plugins.nvim-bqf = {
      enable = true;
      settings = {
        auto_enable = true;
        magic_window = true;
        auto_resize_height = false;
        previous_winid_ft_skip.__empty = { };
        preview = {
          auto_preview = true;
          border = "rounded";
          show_title = true;
          show_scroll_bar = true;
          delay_syntax = 50;
          winblend = 12;
          win_height = 15;
          win_vheight = 15;
          wrap = false;
          buf_label = true;
          should_preview_cb.__raw = "nil";
        };
        func_map = {
          open = "<CR>";
          openc = "o";
          drop = "O";
          split = "<C-x>";
          vsplit = "<C-v>";
          tab = "t";
          tabb = "T";
          tabc = "<C-t>";
          tabdrop = "";
          ptogglemode = "zp";
          ptoggleitem = "p";
          ptoggleauto = "P";
          pscrollup = "<C-b>";
          pscrolldown = "<C-f>";
          pscrollorig = "zo";
          prevfile = "<C-p>";
          nextfile = "<C-n>";
          prevhist = "<";
          nexthist = ">";
          lastleave = "'\"";
          stoggleup = "<S-Tab>";
          stoggledown = "<Tab>";
          stogglevm = "<Tab>";
          stogglebuf = "'<Tab>";
          sclear = "z<Tab>";
          filter = "zn";
          filterr = "zN";
          fzffilter = "zf";
        };
        filter = {
          fzf = {
            action_for = {
              "ctrl-t" = "tabedit";
              "ctrl-v" = "vsplit";
              "ctrl-x" = "split";
              "ctrl-q" = "signtoggle";
              "ctrl-c" = "closeall";
            };
            extra_opts = [
              "--bind"
              "ctrl-o:toggle-all"
            ];
          };
        };
      };
    };
  };
}
