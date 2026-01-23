{
  empty = {
    plugins.arrow.enable = true;
  };

  defaults = {
    plugins.arrow = {
      enable = true;

      settings = {
        show_icons = true;
        always_show_path = false;
        separate_by_branch = false;
        hide_handbook = false;
        save_path = ''
          function()
              return vim.fn.stdpath("cache") .. "/arrow"
          end
        '';
        mappings = {
          edit = "e";
          delete_mode = "d";
          clear_all_items = "C";
          toggle = "s";
          open_vertical = "v";
          open_horizontal = "-";
          quit = "q";
          remove = "x";
          next_item = "]";
          prev_item = "[";
        };
        custom_actions = {
          open = "function(target_file_name, current_file_name) end";
          split_vertical = "function(target_file_name, current_file_name) end";
          split_horizontal = "function(target_file_name, current_file_name) end";
        };
        window = {
          width = "auto";
          height = "auto";
          row = "auto";
          col = "auto";
          border = "double";
        };
        per_buffer_config = {
          lines = 4;
          sort_automatically = true;
          satellite = {
            enable = false;
            overlap = true;
            priority = 1000;
          };
          zindex = 10;
        };
        separate_save_and_remove = false;
        leader_key = ";";
        save_key = "cwd";
        global_bookmarks = false;
        index_keys = "123456789zxcbnmZXVBNM,afghjklAFGHJKLwrtyuiopWRTYUIOP";
        full_path_list = [ "update_stuff" ];
      };
    };
  };

  example = {
    plugins.arrow = {
      enable = true;

      settings = {
        show_icons = true;
        leader_key = ";";
        window = {
          width = 50;
          height = "auto";
          row = "auto";
          col = "auto";
          border = "double";
        };
        index_keys = "azertyuiopAZERTYUIOP123456789";
      };
    };
  };
}
