{
  empty = {
    plugins.yazi.enable = true;
  };

  defaults = {
    plugins.yazi = {
      enable = true;

      settings = {
        log_level = "off";
        open_for_directories = false;
        use_ya_for_events_reading = false;
        use_yazi_client_id_flag = false;
        enable_mouse_support = false;

        open_file_function.__raw = ''
          function(chosen_file)
            vim.cmd(string.format("edit %s", vim.fn.fnameescape(chosen_file)))
          end
        '';

        clipboard_register = "*";

        keymaps = {
          show_help = "<f1>";
          open_file_in_vertical_split = "<c-v>";
          open_file_in_horizontal_split = "<c-x>";
          open_file_in_tab = "<c-t>";
          grep_in_directory = "<c-s>";
          replace_in_directory = "<c-g>";
          cycle_open_buffers = "<tab>";
          copy_relative_path_to_selected_files = "<c-y>";
          send_to_quickfix_list = "<c-q>";
        };

        set_keymappings_function.__raw = "nil";

        hooks = {
          yazi_opened.__raw = ''
            function(preselected_path, yazi_buffer_id, config)
            end
          '';

          yazi_closed_successfully.__raw = ''
            function(chosen_file, config, state)
            end
          '';

          yazi_opened_multiple_files.__raw = ''
            function(chosen_files)
              vim.cmd("args" .. table.concat(chosen_files, " "))
            end
          '';
        };

        highlight_groups = {
          hovered_buffer.__raw = "nil";
        };

        floating_window_scaling_factor = 0.9;
        yazi_floating_window_winblend = 0;
        yazi_floating_window_border = "rounded";
      };
    };
  };
}
