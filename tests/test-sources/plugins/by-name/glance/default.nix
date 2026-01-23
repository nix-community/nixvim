{
  empty = {
    plugins.glance.enable = true;
  };

  default = {
    plugins.glance = {
      enable = true;

      settings = {
        height = 18;
        zindex = 45;
        preserve_win_context = true;
        detached.__raw = ''
          function(winid)
            -- Automatically detach when parent window width < 100 columns
            return vim.api.nvim_win_get_width(winid) < 100
          end
        '';
        preview_win_opts = {
          cursorline = true;
          number = true;
          wrap = true;
        };
        border = {
          enable = false;
          top_char = "―";
          bottom_char = "―";
        };
        list = {
          position = "right";
          width = 0.33;
        };
        theme = {
          enable = true;
          mode = "auto";
        };
        mappings = {
          list = {
            "j".__raw = "require('glance').actions.next";
            "k".__raw = "require('glance').actions.previous";
            "<Down>".__raw = "require('glance').actions.next";
            "<Up>".__raw = "require('glance').actions.previous";
            "<Tab>".__raw = "require('glance').actions.next_location";
            "<S-Tab>".__raw = "require('glance').actions.previous_location";
            "<C-u>".__raw = "require('glance').actions.preview_scroll_win(5)";
            "<C-d>".__raw = "require('glance').actions.preview_scroll_win(-5)";
            "v".__raw = "require('glance').actions.jump_vsplit";
            "s".__raw = "require('glance').actions.jump_split";
            "t".__raw = "require('glance').actions.jump_tab";
            "<CR>".__raw = "require('glance').actions.jump";
            "o".__raw = "require('glance').actions.jump";
            "l".__raw = "require('glance').actions.open_fold";
            "h".__raw = "require('glance').actions.close_fold";
            "<leader>l".__raw = ''require('glance').actions.enter_win("preview")'';
            "q".__raw = "require('glance').actions.close";
            "Q".__raw = "require('glance').actions.close";
            "<Esc>".__raw = "require('glance').actions.close";
            "<C-q>".__raw = "require('glance').actions.quickfix";
          };
          preview = {
            "Q".__raw = "require('glance').actions.close";
            "<Tab>".__raw = "require('glance').actions.next_location";
            "<S-Tab>".__raw = "require('glance').actions.previous_location";
            "<leader>l".__raw = ''require('glance').actions.enter_win("list")'';
          };
        };
        hooks.__empty = { };
        folds = {
          fold_closed = "";
          fold_open = "";
          folded = true;
        };
        indent_lines = {
          enable = true;
          icon = "│";
        };
        winbar = {
          enable = true;
        };
        use_trouble_qf = false;
      };
    };
  };

  trouble = {
    plugins = {
      glance = {
        enable = true;

        settings.use_trouble_qf = true;
      };
      trouble.enable = true;
      web-devicons.enable = true;
    };
  };
}
