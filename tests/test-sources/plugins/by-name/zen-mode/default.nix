{
  empty = {
    plugins.zen-mode.enable = true;
  };

  defaults = {
    plugins.zen-mode = {
      enable = true;

      settings = {
        window = {
          backdrop = 0.95;
          width = 120;
          height = 1;
          options.__empty = { };
        };
        plugins = {
          options = {
            enabled = true;
            ruler = false;
            showcmd = false;
            laststatus = 0;
          };

          twilight.enabled = true;
          gitsigns.enabled = false;
          tmux.enabled = false;
          kitty = {
            enabled = false;
            font = "+4";
          };
          alacritty = {
            enabled = false;
            font = "14";
          };
          wezterm = {
            enabled = false;
            font = "+4";
          };
        };
        on_open = "function(win) end";
        on_close = "function(win) end";
      };
    };
  };

  example = {
    plugins.zen-mode = {
      enable = true;

      settings = {
        window = {
          backdrop = 0.95;
          width = 0.8;
          height = 1;
          options.signcolumn = "no";
        };
        plugins = {
          options = {
            enabled = true;
            ruler = false;
            showcmd = false;
          };
          twilight.enabled = false;
          gitsigns.enabled = true;
          tmux.enabled = false;
        };
        on_open = ''
          function()
            require("gitsigns.actions").toggle_current_line_blame()
            vim.cmd('IBLDisable')
            vim.opt.relativenumber = false
            vim.opt.signcolumn = "no"
            require("gitsigns.actions").refresh()
          end
        '';
        on_close = ''
          function()
            require("gitsigns.actions").toggle_current_line_blame()
            vim.cmd('IBLEnable')
            vim.opt.relativenumber = true
            vim.opt.signcolumn = "yes:2"
            require("gitsigns.actions").refresh()
          end
        '';
      };
    };
  };
}
