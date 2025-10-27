{
  empty = {
    plugins.aerial.enable = true;
  };

  example = {
    plugins.aerial = {
      enable = true;

      settings = {
        backends = [
          "treesitter"
          "lsp"
          "markdown"
          "asciidoc"
          "man"
        ];
        layout = {
          max_width = [
            40
            0.2
          ];
          width.__raw = "nil";
          min_width = 10;
          win_opts.__empty = { };
          default_direction = "prefer_right";
          placement = "window";
          resize_to_content = true;
          preserve_equality = false;
        };
        attach_mode = "window";
        close_automatic_events.__empty = { };
        keymaps = {
          "?" = "actions.show_help";
          "g?" = "actions.show_help";
          "<CR>" = "actions.jump";
          "<2-LeftMouse>" = "actions.jump";
          "<C-v>" = "actions.jump_vsplit";
          "<C-s>" = "actions.jump_split";
          p = "actions.scroll";
          "<C-j>" = "actions.down_and_scroll";
          "<C-k>" = "actions.up_and_scroll";
          "{" = "actions.prev";
          "}" = "actions.next";
          "[[" = "actions.prev_up";
          "]]" = "actions.next_up";
          q = "actions.close";
          o = "actions.tree_toggle";
          za = "actions.tree_toggle";
          O = "actions.tree_toggle_recursive";
          zA = "actions.tree_toggle_recursive";
          l = "actions.tree_open";
          zo = "actions.tree_open";
          L = "actions.tree_open_recursive";
          zO = "actions.tree_open_recursive";
          h = "actions.tree_close";
          zc = "actions.tree_close";
          H = "actions.tree_close_recursive";
          zC = "actions.tree_close_recursive";
          zr = "actions.tree_increase_fold_level";
          zR = "actions.tree_open_all";
          zm = "actions.tree_decrease_fold_level";
          zM = "actions.tree_close_all";
          zx = "actions.tree_sync_folds";
          zX = "actions.tree_sync_folds";
        };
        lazy_load = true;
        disable_max_lines = 10000;
        disable_max_size = 2000000;
        filter_kind = [
          "Class"
          "Constructor"
          "Enum"
          "Function"
          "Interface"
          "Module"
          "Method"
          "Struct"
        ];
        highlight_mode = "split_width";
        highlight_closest = true;
        highlight_on_hover = false;
        highlight_on_jump = 300;
        autojump = false;
        icons.__empty = { };
        ignore = {
          unlisted_buffers = false;
          diff_windows = true;
          filetypes.__empty = { };
          buftypes = "special";
          wintypes = "special";
        };
        manage_folds = false;
        link_folds_to_tree = false;
        link_tree_to_folds = true;
        nerd_font = "auto";
        on_attach.__raw = "function(bufnr) end";
        on_first_symbols.__raw = "function(bufnr) end";
        open_automatic = false;
        post_jump_cmd = "normal! zz";
        post_parse_symbol.__raw = ''
          function(bufnr, item, ctx)
            return true
          end
        '';
        post_add_all_symbols.__raw = ''
          function(bufnr, items, ctx)
            return items
          end
        '';
        close_on_select = false;
        update_events = "TextChanged,InsertLeave";
        show_guides = false;
        guides = {
          mid_item = "├─";
          last_item = "└─";
          nested_top = "│ ";
          whitespace = "  ";
        };
        get_highlight.__raw = ''
          function(symbol, is_icon, is_collapsed)
            -- return "MyHighlight" .. symbol.kind
          end
        '';
        float = {
          border = "rounded";
          relative = "cursor";
          max_height = 0.9;
          height.__raw = "nil";
          min_height = [
            8
            0.1
          ];
          override.__raw = ''
            function(conf, source_winid)
              -- This is the config that will be passed to nvim_open_win.
              -- Change values here to customize the layout
              return conf
            end
          '';
        };
        nav = {
          border = "rounded";
          max_height = 0.9;
          min_height = [
            10
            0.1
          ];
          max_width = 0.5;
          min_width = [
            0.2
            20
          ];
          win_opts = {
            cursorline = true;
            winblend = 10;
          };
          autojump = false;
          preview = false;
          keymaps = {
            "<CR>" = "actions.jump";
            "<2-LeftMouse>" = "actions.jump";
            "<C-v>" = "actions.jump_vsplit";
            "<C-s>" = "actions.jump_split";
            h = "actions.left";
            l = "actions.right";
            "<C-c>" = "actions.close";
          };
        };
        lsp = {
          diagnostics_trigger_update = false;
          update_when_errors = true;
          update_delay = 300;
          priority.__empty = { };
        };
        treesitter = {
          update_delay = 300;
        };
        markdown = {
          update_delay = 300;
        };
        asciidoc = {
          update_delay = 300;
        };
        man = {
          update_delay = 300;
        };
      };
    };
  };

  defaults = {
    plugins.aerial = {
      enable = true;

      settings = {
        backends = [
          "treesitter"
          "lsp"
          "markdown"
          "man"
        ];
        attach_mode = "global";
        disable_max_lines = 5000;
        highlight_on_hover = true;
        ignore.filetypes = [ "gomod" ];
      };
    };
  };
}
