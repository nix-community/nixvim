{
  empty = {
    plugins.harpoon.enable = true;
  };

  defaults = {
    plugins.harpoon = {
      enable = true;

      # https://github.com/ThePrimeagen/harpoon/blob/harpoon2/lua/harpoon/config.lua
      settings = {
        settings = {
          save_on_toggle = false;
          sync_on_ui_close = false;
          key.__raw = ''
            function()
              return vim.uv.cwd()
            end
          '';
        };
        default = {
          select_with_nil = false;
          encode.__raw = ''
            function(obj)
              return vim.json.encode(obj)
            end
          '';
          decode.__raw = ''
            function(str)
              return vim.json.decode(str)
            end
          '';
          display.__raw = ''
            function(list_item)
              return list_item.value
            end
          '';
          # Very long functions omitted for the sake of conciseness
        };
      };
    };
  };

  example = {
    plugins.harpoon = {
      enable = true;

      settings = {
        settings = {
          save_on_toggle = true;
          sync_on_ui_close = false;
        };

        # https://github.com/ThePrimeagen/harpoon/tree/harpoon2?tab=readme-ov-file#-api
        cmd = {
          add.__raw = ''
            function(possible_value)
              -- get the current line idx
              local idx = vim.fn.line(".")

              -- read the current line
              local cmd = vim.api.nvim_buf_get_lines(0, idx - 1, idx, false)[1]
              if cmd == nil then
                  return nil
              end

              return {
                  value = cmd,
                  context = { },
              }
            end
          '';

          select.__raw = ''
            function(list_item, list, option)
              vim.cmd(list_item.value)
            end
          '';
        };
      };
    };
  };

  telescopeEnabled = {
    plugins = {
      telescope.enable = true;
      web-devicons.enable = true;

      harpoon = {
        enable = true;

        enableTelescope = true;
      };
    };
  };
}
