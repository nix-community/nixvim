{ lib }:
{
  empty = {
    plugins.tv.enable = true;
  };

  defaults = {
    plugins.tv = {
      enable = true;
      settings = {
        window = {
          width = 0.8;
          height = 0.8;
          border = "none";
          title = " tv.nvim ";
          title_pos = "center";
        };

        channels = {
          files = {
            keybinding = "<C-p>";
            handlers = {
              "<CR>" = lib.nixvim.mkRaw "require('tv').handlers.open_as_files";
              "<C-q>" = lib.nixvim.mkRaw "require('tv').handlers.send_to_quickfix";
              "<C-s>" = lib.nixvim.mkRaw "require('tv').handlers.open_in_split";
              "<C-v>" = lib.nixvim.mkRaw "require('tv').handlers.open_in_vsplit";
              "<C-y>" = lib.nixvim.mkRaw "require('tv').handlers.copy_to_clipboard";
            };
          };
          text = {
            keybinding = "<leader><leader>";
            handlers = {
              "<CR>" = lib.nixvim.mkRaw "require('tv').handlers.open_at_line";
              "<C-q>" = lib.nixvim.mkRaw "require('tv').handlers.send_to_quickfix";
              "<C-s>" = lib.nixvim.mkRaw "require('tv').handlers.open_in_split";
              "<C-v>" = lib.nixvim.mkRaw "require('tv').handlers.open_in_vsplit";
              "<C-y>" = lib.nixvim.mkRaw "require('tv').handlers.copy_to_clipboard";
            };
          };
          git-log = {
            keybinding = "<leader>gl";
            handlers = {
              "<CR>" = lib.nixvim.mkRaw ''
                function(entries, config)
                  if #entries > 0 then
                    vim.cmd('enew | setlocal buftype=nofile bufhidden=wipe')
                    vim.cmd('silent 0read !git show ' .. vim.fn.shellescape(entries[1]))
                    vim.cmd('1delete _ | setlocal filetype=git nomodifiable')
                    vim.cmd('normal! gg')
                  end
                end
              '';
              "<C-y>" = lib.nixvim.mkRaw "require('tv').handlers.copy_to_clipboard";
            };
          };
          git-branch = {
            keybinding = "<leader>gb";
            handlers = {
              "<CR>" = lib.nixvim.mkRaw "require('tv').handlers.execute_shell_command('git checkout {}')";
              "<C-y>" = lib.nixvim.mkRaw "require('tv').handlers.copy_to_clipboard";
            };
          };
          docker-images = {
            keybinding = "<leader>di";
            window = {
              title = " Docker Images ";
            };
            handlers = {
              "<CR>" = lib.nixvim.mkRaw ''
                function(entries, config)
                  if #entries > 0 then
                    vim.ui.input({
                      prompt = 'Container name: ',
                      default = 'my-container',
                    }, function(name)
                      if name and name ~= "" then
                        local cmd = string.format('docker run -it --name %s %s', name, entries[1])
                        vim.cmd('!' .. cmd)
                      end
                    end)
                  end
                end
              '';
              "<C-y>" = lib.nixvim.mkRaw "require('tv').handlers.copy_to_clipboard";
            };
          };
          env = {
            keybinding = "<leader>ev";
            handlers = {
              "<CR>" = lib.nixvim.mkRaw "require('tv').handlers.insert_at_cursor";
              "<C-l>" = lib.nixvim.mkRaw "require('tv').handlers.insert_on_new_line";
              "<C-y>" = lib.nixvim.mkRaw "require('tv').handlers.copy_to_clipboard";
            };
          };
          alias = {
            keybinding = "<leader>al";
            handlers = {
              "<CR>" = lib.nixvim.mkRaw "require('tv').handlers.insert_at_cursor";
              "<C-y>" = lib.nixvim.mkRaw "require('tv').handlers.copy_to_clipboard";
            };
          };
        };
        global_keybindings.channels = "<leader>tv";
        quickfix.auto_open = false;
        tv_binary = "tv";
      };
    };
  };

  example = {
    plugins.tv = {
      enable = true;

      settings = {
        global_keybindings.channels = "<leader>tv";
        quickfix.auto_open = false;
        tv_binary = "tv";
      };
    };
  };
}
