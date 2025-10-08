{ lib, ... }:
{
  empty = {
    plugins.cybu = {
      enable = true;
      settings.style.devicons.enabled = false;
    };
  };

  example = {
    plugins.cybu = {
      enable = true;

      settings = {
        style.devicons.enabled = false;
        behavior = {
          mode = {
            default = {
              switch = "immediate";
              view = "rolling";
            };
            last_used = {
              switch = "on_close";
              view = "paging";
              update_on = "buf_enter";
            };
          };
        };
        display_time = 750;
      };
    };
  };

  defaults = {
    plugins.cybu = {
      enable = true;

      settings = {
        position = {
          relative_to = "win";
          anchor = "topcenter";
          vertical_offset = 10;
          horizontal_offset = 0;
          max_win_height = 5;
          max_win_width = 0.5;
        };
        style = {
          path = "relative";
          path_abbreviation = "none";
          border = "rounded";
          separator = " ";
          prefix = "…";
          padding = 1;
          hide_buffer_id = true;
          devicons = {
            enabled = false;
            colored = true;
            truncate = true;
          };
          highlights = {
            current_buffer = "CybuFocus";
            adjacent_buffers = "CybuAdjacent";
            background = "CybuBackground";
            border = "CybuBorder";
          };
        };
        behavior = {
          mode = {
            default = {
              switch = "immediate";
              view = "rolling";
            };
            last_used = {
              switch = "on_close";
              view = "paging";
              update_on = "buf_enter";
            };
            auto = {
              view = "rolling";
            };
          };
          show_on_autocmd = false;
        };
        display_time = 750;
        exclude = [
          "neo-tree"
          "fugitive"
          "qf"
        ];
        filter = {
          unlisted = true;
        };
        fallback = lib.nixvim.mkRaw "function() end";
      };
    };
  };
}
