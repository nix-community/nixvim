{
  empty = {
    plugins.web-devicons.enable = true;
    plugins.bufferline.enable = true;
  };

  example = {
    plugins.web-devicons.enable = true;
    plugins.bufferline = {
      enable = true;
      settings = {
        options = {
          custom_filter = # Lua
            ''
              function(buf_number, buf_numbers)
                -- filter out filetypes you don't want to see
                if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                    return true
                end
                -- filter out by buffer name
                if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                    return true
                end
                -- filter out based on arbitrary rules
                -- e.g. filter out vim wiki buffer from tabline in your work repo
                if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                    return true
                end
                -- filter out by it's index number in list (don't show first buffer)
                if buf_numbers[1] ~= buf_number then
                    return true
                end
              end
            '';
          get_element_icon = # Lua
            ''
              function(element)
                -- element consists of {filetype: string, path: string, extension: string, directory: string}
                -- This can be used to change how bufferline fetches the icon
                -- for an element e.g. a buffer or a tab.
                -- e.g.
                local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(opts.filetype, { default = false })
                return icon, hl
              end
            '';
          separator_style = [
            "|"
            "|"
          ];
          sort_by.__raw = ''
            function(buffer_a, buffer_b)
                local modified_a = vim.fn.getftime(buffer_a.path)
                local modified_b = vim.fn.getftime(buffer_b.path)
                return modified_a > modified_b
            end
          '';
        };
      };
    };
  };

  defaults = {
    plugins.web-devicons.enable = true;
    plugins.bufferline = {
      enable = true;
      settings = {
        options = {
          mode = "buffers";
          themable = true;
          numbers = "none";
          buffer_close_icon = "";
          modified_icon = "●";
          close_icon = "";
          close_command = "bdelete! %d";
          left_mouse_command = "buffer %d";
          right_mouse_command = "bdelete! %d";
          middle_mouse_command = null;
          indicator = {
            icon = "▎";
            style = "icon";
          };
          left_trunc_marker = "";
          right_trunc_marker = "";
          separator_style = "thin";
          name_formatter = null;
          truncate_names = true;
          tab_size = 18;
          max_name_length = 18;
          color_icons = true;
          show_buffer_icons = true;
          show_buffer_close_icons = true;
          get_element_icon = null;
          show_close_icon = true;
          show_tab_indicators = true;
          show_duplicate_prefix = true;
          duplicates_across_groups = true;
          enforce_regular_tabs = false;
          always_show_bufferline = true;
          auto_toggle_bufferline = true;
          persist_buffer_sort = true;
          move_wraps_at_ends = false;
          max_prefix_length = 15;
          sort_by = "id";
          diagnostics = false;
          diagnostics_indicator = null;
          diagnostics_update_in_insert = true;
          diagnostics_update_on_event = true;
          offsets = null;
          groups = {
            items = [ ];
            options = {
              toggle_hidden_on_enter = true;
            };
          };
          hover = {
            enabled = false;
            reveal = [ ];
            delay = 200;
          };
          debug = {
            logging = false;
          };
          custom_filter = null;
        };
        highlights = { };
      };
    };
  };

  no-icons = {
    plugins.web-devicons.enable = false;
    plugins.bufferline = {
      enable = true;
    };
  };
}
