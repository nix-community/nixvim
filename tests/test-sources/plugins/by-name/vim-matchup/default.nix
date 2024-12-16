{
  empty = {
    plugins.vim-matchup.enable = true;
  };

  defaults = {
    plugins.vim-matchup = {
      enable = true;

      settings = {
        enabled = 1;
        mappings_enabled = 1;
        mouse_enabled = 1;
        motion_enabled = 1;
        text_obj_enabled = 1;
        transmute_enabled = 0;
        delim_stopline = 1500;
        delim_noskips = 0;
        delim_nomids = 0;
        delim_start_plaintext = 1;
        matchparen_enabled = 1;
        matchparen_singleton = 0;
        matchparen_offscreen.method = "status";
        matchparen_stopline = 400;
        matchparen_timeout = 300;
        matchparen_insert_timeout = 60;
        matchparen_deferred = 0;
        matchparen_deferred_show_delay = 50;
        matchparen_deferred_hide_delay = 700;
        matchparen_deferred_fade_time = 0;
        matchparen_pumvisible = 1;
        matchparen_nomode = "";
        matchparen_hi_surround_always = 0;
        matchparen_hi_background = 0;
        matchparen_end_sign = "◀";
        motion_override_Npercent = 6;
        motion_cursor_end = 1;
        delim_count_fail = 0;
        text_obj_linewise_operators = [
          "d"
          "y"
        ];
        surround_enabled = 0;
        override_vimtex = 0;
      };
    };
  };

  example = {
    plugins = {
      treesitter.enable = true;
      vim-matchup = {
        enable = true;

        treesitter = {
          enable = true;
          disable = [
            "c"
            "ruby"
          ];
        };

        settings = {
          mouse_enabled = 0;
          surround_enabled = 1;
          transmute_enabled = 1;
          matchparen_offscreen.method = "popup";
        };
      };
    };
  };
}
