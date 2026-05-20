{
  empty = {
    plugins.trailblazer.enable = true;
  };

  defaults = {
    plugins.trailblazer = {
      enable = true;
      settings = {
        lang = "en";
        auto_save_trailblazer_state_on_exit = false;
        auto_load_trailblazer_state_on_enter = false;
        custom_session_storage_dir = "";
        trail_options = {
          trail_mark_priority = 10001;
          available_trail_mark_modes = [
            "global_chron"
            "global_buf_line_sorted"
            "global_fpath_line_sorted"
            "global_chron_buf_line_sorted"
            "global_chron_fpath_line_sorted"
            "global_chron_buf_switch_group_chron"
            "global_chron_buf_switch_group_line_sorted"
            "buffer_local_chron"
            "buffer_local_line_sorted"
          ];
          current_trail_mark_mode = "global_chron";
          current_trail_mark_list_type = "quickfix";
          trail_mark_list_rows = 10;
          verbose_trail_mark_select = true;
          mark_symbol = "•";
          newest_mark_symbol = "⬤";
          cursor_mark_symbol = "⬤";
          next_mark_symbol = "⬤";
          previous_mark_symbol = "⬤";
          multiple_mark_symbol_counters_enabled = true;
          number_line_color_enabled = true;
          trail_mark_in_text_highlights_enabled = true;
          trail_mark_symbol_line_indicators_enabled = false;
          symbol_line_enabled = true;
          default_trail_mark_stacks = [ "default" ];
          available_trail_mark_stack_sort_modes = [
            "alpha_asc"
            "alpha_dsc"
            "chron_asc"
            "chron_dsc"
          ];
          current_trail_mark_stack_sort_mode = "alpha_asc";
          move_to_nearest_before_peek = false;
          move_to_nearest_before_peek_motion_directive_up = "fpath_up";
          move_to_nearest_before_peek_motion_directive_down = "fpath_down";
          move_to_nearest_before_peek_dist_type = "lin_char_dist";
        };
        mappings.nv = {
          motions = {
            new_trail_mark = "<A-l>";
            track_back = "<A-b>";
            peek_move_next_down = "<A-J>";
            peek_move_previous_up = "<A-K>";
            move_to_nearest = "<A-n>";
            toggle_trail_mark_list = "<A-m>";
          };
          actions = {
            delete_all_trail_marks = "<A-L>";
            paste_at_last_trail_mark = "<A-p>";
            paste_at_all_trail_marks = "<A-P>";
            set_trail_mark_select_mode = "<A-t>";
            switch_to_next_trail_mark_stack = "<A-.>";
            switch_to_previous_trail_mark_stack = "<A-,>";
            set_trail_mark_stack_sort_mode = "<A-s>";
          };
        };
        quickfix_mappings = {
          nv = {
            motions.qf_motion_move_trail_mark_stack_cursor = "<CR>";
            actions = {
              qf_action_delete_trail_mark_selection = "d";
              qf_action_save_visual_selection_start_line = "v";
            };
            alt_actions.qf_action_save_visual_selection_start_line = "V";
          };
          v.actions = {
            qf_action_move_selected_trail_marks_down = "<C-j>";
            qf_action_move_selected_trail_marks_up = "<C-k>";
          };
        };
        hl_groups = {
          TrailBlazerTrailMark = {
            guifg = "White";
            guibg = "none";
            gui = "bold";
          };
          TrailBlazerTrailMarkNext = {
            guifg = "Green";
            guibg = "none";
            gui = "bold";
          };
          TrailBlazerTrailMarkPrevious = {
            guifg = "Red";
            guibg = "none";
            gui = "bold";
          };
          TrailBlazerTrailMarkCursor = {
            guifg = "Black";
            guibg = "Orange";
            gui = "bold";
          };
          TrailBlazerTrailMarkNewest = {
            guifg = "Black";
            guibg = "LightBlue";
            gui = "bold";
          };
          TrailBlazerTrailMarkCustomOrd = {
            guifg = "Black";
            guibg = "LightSlateBlue";
            gui = "bold";
          };
          TrailBlazerTrailMarkGlobalChron = {
            guifg = "Black";
            guibg = "Red";
            gui = "bold";
          };
          TrailBlazerTrailMarkGlobalBufLineSorted = {
            guifg = "Black";
            guibg = "LightRed";
            gui = "bold";
          };
          TrailBlazerTrailMarkGlobalFpathLineSorted = {
            guifg = "Black";
            guibg = "LightRed";
            gui = "bold";
          };
          TrailBlazerTrailMarkGlobalChronBufLineSorted = {
            guifg = "Black";
            guibg = "Olive";
            gui = "bold";
          };
          TrailBlazerTrailMarkGlobalChronFpathLineSorted = {
            guifg = "Black";
            guibg = "Olive";
            gui = "bold";
          };
          TrailBlazerTrailMarkGlobalChronBufSwitchGroupChron = {
            guifg = "Black";
            guibg = "VioletRed";
            gui = "bold";
          };
          TrailBlazerTrailMarkGlobalChronBufSwitchGroupLineSorted = {
            guifg = "Black";
            guibg = "MediumSpringGreen";
            gui = "bold";
          };
          TrailBlazerTrailMarkBufferLocalChron = {
            guifg = "Black";
            guibg = "Green";
            gui = "bold";
          };
          TrailBlazerTrailMarkBufferLocalLineSorted = {
            guifg = "Black";
            guibg = "LightGreen";
            gui = "bold";
          };
        };
      };
    };
  };

  example = {
    plugins.trailblazer = {
      enable = true;
      settings = {
        auto_save_trailblazer_state_on_exit = true;
        trail_options = {
          current_trail_mark_mode = "buffer_local_line_sorted";
          mark_symbol = "●";
          newest_mark_symbol = "◆";
        };
        mappings.nv.motions.new_trail_mark = "<leader>m";
      };
    };
  };
}
