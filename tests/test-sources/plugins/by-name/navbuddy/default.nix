{
  empty = {
    plugins.navbuddy.enable = true;
  };

  example = {
    plugins.navbuddy = {
      settings = {
        lsp.auto_attach = true;
        use_default_mapping = true;
        mappings = {
          "<esc>".__raw = "require('nvim-navbuddy.actions').close()";
          "q".__raw = "require('nvim-navbuddy.actions').close()";
          "j".__raw = "require('nvim-navbuddy.actions').next_sibling()";
          "k".__raw = "require('nvim-navbuddy.actions').previous_sibling()";
          "<C-v>".__raw = "require('nvim-navbuddy.actions').vsplit()";
          "<C-s>".__raw = "require('nvim-navbuddy.actions').hsplit()";
        };
        icons = {
          Array = "> ";
          Boolean = "> ";
          Class = "> ";
        };
      };
    };
  };

  defaults = {
    plugins.navbuddy = {
      enable = true;
      settings = {
        window = {
          border = "single";
          size = "60%";
          position = "50%";
          scrolloff.__raw = "nil";
          sections = {
            left = {
              border.__raw = "nil";
              size = "20%";
              win_options.__raw = "nil";
            };
            mid = {
              border.__raw = "nil";
              size = "40%";
              win_options.__empty = { };
            };
            right = {
              border.__raw = "nil";
              preview = "leaf";
              win_options.__raw = "nil";
            };
          };
        };
        icons = {
          "1" = "󰈙 ";
          "2" = " ";
          "3" = "󰌗 ";
          "4" = " ";
          "5" = "󰌗 ";
          "6" = "󰆧 ";
          "7" = " ";
          "8" = " ";
          "9" = " ";
          "10" = "󰕘";
          "11" = "󰕘";
          "12" = "󰊕 ";
          "13" = "󰆧 ";
          "14" = "󰏿 ";
          "15" = " ";
          "16" = "󰎠 ";
          "17" = "◩ ";
          "18" = "󰅪 ";
          "19" = "󰅩 ";
          "20" = "󰌋 ";
          "21" = "󰟢 ";
          "22" = " ";
          "23" = "󰌗 ";
          "24" = " ";
          "25" = "󰆕 ";
          "26" = "󰊄 ";
          "255" = "󰉨 ";
        };
        use_default_mappings = true;
        integrations = {
          telescope.__raw = "nil";
          snacks.__raw = "nil";
        };
        mappings = {
          "<esc>".__raw = "require('nvim-navbuddy.actions').close()";
          q.__raw = "require('nvim-navbuddy.actions').close()";

          j.__raw = "require('nvim-navbuddy.actions').next_sibling()";
          k.__raw = "require('nvim-navbuddy.actions').previous_sibling()";

          h.__raw = "require('nvim-navbuddy.actions').parent()";
          l.__raw = "require('nvim-navbuddy.actions').children()";
          "0".__raw = "require('nvim-navbuddy.actions').root()";

          v.__raw = "require('nvim-navbuddy.actions').visual_name()";
          V.__raw = "require('nvim-navbuddy.actions').visual_scope()";

          y.__raw = "require('nvim-navbuddy.actions').yank_name()";
          Y.__raw = "require('nvim-navbuddy.actions').yank_scope()";

          i.__raw = "require('nvim-navbuddy.actions').insert_name()";
          I.__raw = "require('nvim-navbuddy.actions').insert_scope()";

          a.__raw = "require('nvim-navbuddy.actions').append_name()";
          A.__raw = "require('nvim-navbuddy.actions').append_scope()";

          r.__raw = "require('nvim-navbuddy.actions').rename()";

          d.__raw = "require('nvim-navbuddy.actions').delete()";

          f.__raw = "require('nvim-navbuddy.actions').fold_create()";
          F.__raw = "require('nvim-navbuddy.actions').fold_delete()";

          c.__raw = "require('nvim-navbuddy.actions').comment()";

          "<enter>".__raw = "require('nvim-navbuddy.actions').select()";
          o.__raw = "require('nvim-navbuddy.actions').select()";

          J.__raw = "require('nvim-navbuddy.actions').move_down()";
          K.__raw = "require('nvim-navbuddy.actions').move_up()";

          s.__raw = "require('nvim-navbuddy.actions').toggle_preview()";

          "<C-v>".__raw = "require('nvim-navbuddy.actions').vsplit()";
          "<C-s>".__raw = "require('nvim-navbuddy.actions').hsplit()";

          "g?".__raw = "require('nvim-navbuddy.actions').help()";
        };
        lsp = {
          auto_attach = false;
          preference.__raw = "nil";
        };
        source_buffer = {
          follow_node = true;
          highlight = true;
          reorient = "smart";
          scrolloff.__raw = "nil";
        };
        node_markers = {
          enabled = true;
          icons = {
            leaf = "  ";
            leaf_selected = " → ";
            branch = " ";
          };
        };
        custom_hl_group.__raw = "nil";
      };
    };
  };
}
