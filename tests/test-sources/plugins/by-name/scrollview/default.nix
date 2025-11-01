{
  empty = {
    plugins.scrollview.enable = true;
  };

  defaults = {
    plugins.scrollview = {
      enable = true;

      settings = {
        always_show = false;
        base = "right";
        byte_limit = 1000000;
        character = "";
        column = 1;
        consider_border = false;
        current_only = false;
        excluded_filetypes.__empty = { };
        floating_windows = false;
        hide_bar_for_insert = false;
        hide_on_intersect = false;
        hover = true;
        include_end_region = false;
        line_limit = -1;
        mode = "auto";
        mouse_primary = "left";
        mouse_secondary = "right";
        on_startup = true;
        winblend = 50;
        winblend_gui = 0;
        zindex = 40;
        signs_hidden_for_insert.__empty = { };
        signs_max_per_row = -1;
        signs_on_startup = [
          "diagnostics"
          "marks"
          "search"
        ];
        signs_overflow = "left";
        signs_show_in_folds = false;
        changelist_previous_priority = 15;
        changelist_previous_symbol.__raw = "nil";
        changelist_current_priority = 10;
        changelist_current_symbol = "@";
        changelist_next_priority = 5;
        changelist_next_symbol.__raw = "nil";
        conflicts_bottom_priority = 80;
        conflicts_bottom_symbol = ">";
        conflicts_middle_priority = 75;
        conflicts_middle_symbol = "=";
        conflicts_top_priority = 70;
        conflicts_top_symbol = "<";
        cursor_priority = 0;
        cursor_symbol.__raw = "nil";
        diagnostics_error_priority = 60;
        diagnostics_error_symbol = "E";
        diagnostics_hint_priority = 30;
        diagnostics_hint_symbol = "H";
        diagnostics_info_priority = 40;
        diagnostics_info_symbol.__raw = "'I'"; # test rawLua support
        diagnostics_severities.__raw = "nil";
        diagnostics_warn_priority = 50;
        diagnostics_warn_symbol = "W";
        folds_priority = 30;
        folds_symbol.__raw = "nil";
        latestchange_priority = 10;
        latestchange_symbol.__raw = "nil";
        loclist_priority = 45;
        loclist_symbol.__raw = "nil";
        marks_characters.__raw = "nil";
        marks_priority = 50;
        quickfix_priority = 45;
        quickfix_symbol.__raw = "nil";
        search_priority = 70;
        search_symbol = [
          "="
          "="
          { __raw = "vim.fn.nr2char(0x2261)"; }
        ];
        spell_priority = 20;
        spell_symbol = "~";
        textwidth_priority = 20;
        textwidth_symbol.__raw = "nil";
        trail_priority = 50;
        trail_symbol.__raw = "nil";
      };
    };
  };

  example = {
    plugins.scrollview = {
      enable = true;

      settings = {
        excluded_filetypes = [ "nerdtree" ];
        current_only = true;
        base = "buffer";
        column = 80;
        signs_on_startup = [ "all" ];
        diagnostics_severities = [ { __raw = "vim.diagnostic.severity.ERROR"; } ];
      };
    };
  };
}
