{
  empty = {
    plugins.oil.enable = true;
  };

  short-example = {
    plugins.oil = {
      enable = true;

      settings = {
        columns = [ "icon" ];
        view_options.show_hidden = false;
        win_options = {
          wrap = false;
          signcolumn = "no";
          cursorcolumn = false;
          foldcolumn = "0";
          spell = false;
          list = false;
          conceallevel = 3;
          concealcursor = "ncv";
        };
        keymaps = {
          "<C-c>" = false;
          "<leader>qq" = "actions.close";
          "<C-l>" = false;
          "<C-r>" = "actions.refresh";
          "y." = "actions.copy_entry_path";
        };
        skip_confirm_for_simple_edits = true;
      };
    };
  };

  example = {
    plugins.oil = {
      enable = true;

      settings = {
        default_file_explorer = true;
        columns = [
          {
            __unkeyed = "type";
            highlight = "Foo";
            icons.__empty = { };
          }

          {
            __unkeyed = "icon";
            highlight = "Foo";
            defaultFile = "bar";
            directory = "dir";
          }
          {
            __unkeyed = "size";
            highlight = "Foo";
          }
          {
            __unkeyed = "permissions";
            highlight = "Foo";
          }
          {
            __unkeyed = "ctime";
            highlight = "Foo";
            format = "format";
          }
          {
            __unkeyed = "mtime";
            highlight = "Foo";
            format = "format";
          }
          {
            __unkeyed = "atime";
            highlight = "Foo";
            format = "format";
          }
          {
            __unkeyed = "birthtime";
            highlight = "Foo";
            format = "format";
          }
        ];
        buf_options = {
          buflisted = false;
          bufhidden = "hide";
        };
        win_options = {
          wrap = false;
          signcolumn = "no";
          cursorcolumn = false;
          foldcolumn = "0";
          spell = false;
          list = false;
          conceallevel = 3;
          concealcursor = "nvic";
        };
        delete_to_trash = false;
        skip_confirm_for_simple_edits = false;
        prompt_save_on_select_new_entry = true;
        cleanup_delay_ms = 2000;
        lsp_file_method = {
          timeout_ms = 1000;
          autosave_changes = true;
        };
        constrain_cursor = "editable";
        experimental_watch_for_changes = false;
        keymaps = {
          "g?" = "actions.show_help";
          "<CR>" = "actions.select";
          "<C-s>" = "actions.select_vsplit";
          "<C-h>" = "actions.select_split";
          "<C-t>" = "actions.select_tab";
          "<C-p>" = "actions.preview";
          "<C-c>" = "actions.close";
          "<C-l>" = "actions.refresh";
          "-" = "actions.parent";
          "_" = "actions.open_cwd";
          "`" = "actions.cd";
          "~" = "actions.tcd";
          "g." = "actions.toggle_hidden";
        };
        keymaps_help = {
          border = "rounded";
        };
        use_default_keymaps = true;
        view_options = {
          show_hidden = false;
          is_hidden_file = ''
            function(name, bufnr)
              return vim.startswith(name, ".")
            end
          '';
          is_always_hidden = ''
            function(name, bufnr)
              return false
            end
          '';
          natural_order = true;
          sort = [
            [
              "type"
              "asc"
            ]
            [
              "name"
              "asc"
            ]
          ];
        };
        float = {
          padding = 2;
          max_width = 0;
          max_height = 0;
          border = "rounded";
          win_options = {
            winblend = 0;
          };
          override = ''
            function(conf)
              return conf
            end
          '';
        };
        preview = {
          max_width = 0.9;
          min_width = [
            40
            0.4
          ];
          width.__raw = "nil";
          max_height = 0.9;
          min_height = [
            5
            0.1
          ];
          height.__raw = "nil";
          border = "rounded";
          win_options = {
            winblend = 0;
          };
          update_on_cursor_moved = true;
        };
        progress = {
          max_width = 0.9;
          min_width = [
            40
            0.4
          ];
          width.__raw = "nil";
          max_height = 0.9;
          min_height = [
            5
            0.1
          ];
          height.__raw = "nil";
          border = "rounded";
          minimized_border = "none";
          win_options = {
            winblend = 0;
          };
        };
        ssh = {
          border = "rounded";
        };
      };
    };
  };
}
