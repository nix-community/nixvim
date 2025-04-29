{
  empty = {
    plugins.goto-preview.enable = true;
  };

  defaults = {
    plugins.goto-preview = {
      enable = true;

      settings = {
        width = 120;
        height = 15;
        border = [
          "↖"
          "─"
          "┐"
          "│"
          "┘"
          "─"
          "└"
          "│"
        ];
        default_mappings = false;
        debug = false;
        opacity = null;
        resizing_mappings = false;
        post_open_hook = null;
        post_close_hook = null;
        references = {
          provider = "telescope";
          telescope = null;
        };
        focus_on_open = true;
        dismiss_on_move = false;
        force_close = true;
        bufhidden = "wipe";
        stack_floating_preview_windows = true;
        same_file_float_preview = true;
        preview_window_title = {
          enable = true;
          position = "left";
        };
        zindex = 1;
        vim_ui_input = true;
      };
    };
  };

  withTelescope = {
    plugins = {
      web-devicons.enable = true;
      telescope.enable = true;

      goto-preview = {
        enable = true;
        settings.references = {
          provider = "telescope";
          telescope.__raw = "require('telescope.themes').get_dropdown({ hide_preview = false })";
        };
      };
    };
  };

  example = {
    plugins.goto-preview = {
      enable = true;

      settings = {
        default_mappings = false;
        height = 30;
        post_open_hook.__raw = ''
          function(_, win)
            -- Close the current preview window with <Esc> or 'q'.
            local function close_window()
              vim.api.nvim_win_close(win, true)
            end
            vim.keymap.set('n', '<Esc>', close_window, { buffer = true })
            vim.keymap.set('n', 'q', close_window, { buffer = true })
          end
        '';
      };
    };
  };
}
