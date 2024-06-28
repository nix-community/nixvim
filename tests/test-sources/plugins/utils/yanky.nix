{
  empty = {
    plugins.yanky.enable = true;
  };

  with-telescope = {
    plugins = {
      telescope.enable = true;

      yanky = {
        enable = true;
        enableTelescope = true;
      };
    };
  };

  defaults = {
    plugins.yanky = {
      enable = true;

      settings = {
        ring = {
          history_length = 100;
          storage = "shada";
          storage_path.__raw = "vim.fn.stdpath('data') .. '/databases/yanky.db'";
          sync_with_numbered_registers = true;
          cancel_event = "update";
          ignore_registers = [ "_" ];
          update_register_on_cycle = false;
        };
        picker = {
          select = {
            action = null;
          };
          telescope = {
            use_default_mappings = true;
            mappings = null;
          };
        };
        system_clipboard = {
          sync_with_ring = true;
          clipboard_register = null;
        };
        highlight = {
          on_put = true;
          on_yank = true;
          timer = 500;
        };
        preserve_cursor_position = {
          enabled = true;
        };
        textobj = {
          enabled = true;
        };
      };
    };

  };

  example = {
    plugins = {
      telescope.enable = true;

      yanky = {
        enable = true;

        enableTelescope = true;
        settings = {
          ring = {
            history_length = 100;
            storage = "sqlite";
            storage_path.__raw = "vim.fn.stdpath('data') .. '/databases/yanky.db'";
            sync_with_numbered_registers = true;
            cancel_event = "update";
            ignore_registers = [ "_" ];
            update_register_on_cycle = false;
          };
          telescope = {
            use_default_mappings = true;
            mappings = {
              default = "require('yanky.telescope.mapping').put('p')";
              i = {
                "<c-g>" = "require('yanky.telescope.mapping').put('p')";
                "<c-k>" = "require('yanky.telescope.mapping').put('P')";
                "<c-x>" = "require('yanky.telescope.mapping').delete()";
                "<c-r>" = "require('yanky.telescope.mapping').set_register(require('yanky.utils').get_default_register())";
              };
              n = {
                p = "require('yanky.telescope.mapping').put('p')";
                P = "require('yanky.telescope.mapping').put('P')";
                d = "require('yanky.telescope.mapping').delete()";
                r = "require('yanky.telescope.mapping').set_register(require('yanky.utils').get_default_register())";
              };
            };
          };
          system_clipboard = {
            sync_with_ring = true;
            clipboard_register = null;
          };
          highlight = {
            on_put = true;
            on_yank = true;
            timer = 500;
          };
          preserve_cursor_position = {
            enabled = true;
          };
          textobj = {
            enabled = true;
          };
        };
      };
    };
  };
}
