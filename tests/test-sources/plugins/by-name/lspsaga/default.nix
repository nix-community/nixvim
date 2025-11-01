{
  empty = {
    plugins.web-devicons.enable = true;
    plugins.lspsaga.enable = true;
  };

  defaults = {
    plugins.web-devicons.enable = true;
    plugins.lspsaga = {
      enable = true;
      settings = {
        ui = {
          border = "single";
          devicon = true;
          title = true;
          expand = "⊞";
          collapse = "⊟";
          code_action = "💡";
          actionfix = "";
          lines = [
            "┗"
            "┣"
            "┃"
            "━"
            "┏"
          ];
          kind.__empty = { };
          imp_sign = "󰳛 ";
        };
        hover = {
          max_width = 0.9;
          max_height = 0.8;
          open_link = "gx";
          open_cmd = "!chrome";
        };
        diagnostic = {
          show_code_action = true;
          show_layout = "float";
          show_normal_height = 10;
          jump_num_shortcut = true;
          max_width = 0.8;
          max_height = 0.6;
          max_show_width = 0.9;
          max_show_height = 0.6;
          text_hl_follow = true;
          border_follow = true;
          extend_related_information = false;
          diagnostic_only_current = false;
          keys = {
            exec_action = "o";
            quit = "q";
            toggle_or_jump = "<CR>";
            quit_in_show = [
              "q"
              "<ESC>"
            ];
          };
        };
        code_action = {
          num_shortcut = true;
          show_server_name = false;
          extend_git_signs = false;
          only_in_cursor = true;
          keys = {
            quit = "q";
            exec = "<CR>";
          };
        };
        lightbulb = {
          enable = true;
          sign = true;
          debounce = 10;
          sign_priority = 40;
          virtual_text = true;
        };
        scroll_preview = {
          scroll_down = "<C-f>";
          scroll_up = "<C-b>";
        };
        finder = {
          max_height = 0.5;
          left_width = 0.3;
          right_width = 0.3;
          methods = {
            tyd = "textDocument/typeDefinition";
          };
          default = "ref+imp";
          layout = "float";
          silent = false;
          filter.__empty = { };
          keys = {
            shuttle = "[w";
            toggle_or_open = "o";
            vsplit = "s";
            split = "i";
            tabe = "t";
            tabnew = "r";
            quit = "q";
            close = "<C-c>k";
          };
        };
        definition = {
          width = 0.6;
          height = 0.5;
          keys = {
            edit = "<C-c>o";
            vsplit = "<C-c>v";
            split = "<C-c>i";
            tabe = "<C-c>t";
            quit = "q";
            close = "<C-c>k";
          };
        };
        rename = {
          in_select = true;
          auto_save = false;
          project_max_width = 0.5;
          project_max_height = 0.5;
          keys = {
            quit = "<C-k>";
            exec = "<CR>";
            select = "x";
          };
        };
        symbol_in_winbar = {
          enable = true;
          separator = " › ";
          hide_keyword = false;
          show_file = true;
          folder_level = 1;
          color_mode = true;
          delay = 300;
        };
        outline = {
          win_position = "right";
          win_width = 30;
          auto_preview = true;
          detail = true;
          auto_close = true;
          close_after_jump = false;
          layout = "normal";
          max_height = 0.5;
          left_width = 0.3;
          keys = {
            toggle_or_jump = "o";
            quit = "q";
            jump = "e";
          };
        };
        callhierarchy = {
          layout = "float";
          keys = {
            edit = "e";
            vsplit = "s";
            split = "i";
            tabe = "t";
            close = "<C-c>k";
            quit = "q";
            shuttle = "[w";
            toggle_or_req = "u";
          };
        };
        implement = {
          enable = true;
          sign = true;
          virtual_text = true;
          priority = 100;
        };
        beacon = {
          enable = true;
          frequency = 7;
        };
      };
    };
  };

  example = {
    plugins.web-devicons.enable = true;
    plugins.lspsaga = {
      enable = true;
      settings = {
        ui.border = "single";
        symbol_in_winbar.enable = true;
        implement.enable = true;
        lightbulb.enable = false;
      };
    };
  };

  no-icons = {
    plugins.web-devicons.enable = false;
    plugins.lspsaga = {
      enable = true;
    };
  };
}
