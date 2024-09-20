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

      web-devicons.enable = true;
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
    # TODO: added 2024-09-13
    # re-enable when sqlite fixed
    test.runNvim = false;

    plugins = {
      sqlite-lua.enable = true;
      telescope.enable = true;

      web-devicons.enable = true;
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
              default = "mapping.put('p')";
              i = {
                "<c-g>" = "mapping.put('p')";
                "<c-k>" = "mapping.put('P')";
                "<c-x>" = "mapping.delete()";
                "<c-r>" = "mapping.set_register(utils.get_default_register())";
              };
              n = {
                p = "mapping.put('p')";
                P = "mapping.put('P')";
                d = "mapping.delete()";
                r = "mapping.set_register(utils.get_default_register())";
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
