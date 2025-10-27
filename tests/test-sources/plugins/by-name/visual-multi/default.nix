{
  empty = {
    plugins.visual-multi.enable = true;
  };

  defaults = {
    plugins.visual-multi = {
      enable = true;

      settings = {
        highlight_matches = "underline";
        set_statusline = 2;
        silent_exit = 0;
        quit_after_leaving_insert_mode = 0;
        add_cursor_at_pos_no_mappings = 0;
        show_warnings = 1;
        verbose_commands = 0;
        skip_shorter_lines = 1;
        skip_empty_lines = 0;
        live_editing = 1;
        reselect_first = 0;
        case_setting = "";
        disable_syntax_in_imode = 0;
        recursive_operations_at_cursors = 1;
        custom_remaps.__empty = { };
        custom_noremaps.__empty = { };
        custom_motions.__empty = { };
        user_operators.__empty = { };
        use_first_cursor_in_line = 0;
        insert_special_keys = [ "c-v" ];
        single_mode_maps = 1;
        single_mode_auto_reset = 1;
        filesize_limit = 0;
        persistent_registers = 0;
        reindent_filetypes.__empty = { };
        plugins_compatibilty.__empty = { };

        # FIXME: This is not empty by default. it can't be or it throws
        # maps.__empty = { };

        default_mappings = 1;
        mouse_mappings = 0;
        leader = "\\\\";
      };
    };
  };

  example = {
    plugins.visual-multi = {
      enable = true;

      settings = {
        mouse_mappings = 1;
        silent_exit = 0;
        show_warnings = 1;
        default_mappings = 1;
        maps = {
          "Select All" = "<C-M-n>";
          "Add Cursor Down" = "<M-Down>";
          "Add Cursor Up" = "<M-Up>";
          "Mouse Cursor" = "<M-LeftMouse>";
          "Mouse Word" = "<M-RightMouse>";
        };
      };
    };
  };
}
