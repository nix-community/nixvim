{
  empty = {
    plugins.lf.enable = true;
  };

  defaults = {
    plugins.lf = {
      enable = true;

      settings = {
        default_action = "drop";
        default_actions = {
          "<C-S>" = "tabedit";
          "<C-V>" = "split";
          "<C-L>" = "vsplit";
          "<C-F>" = "tab drop";
        };
        winblend = 10;
        layout_mapping = "<M-u>";
        views = [
          {
            width = 0.8;
            height = 0.8;
          }
          {
            width = 0.2;
            height = 0.9;
            col = 0;
            row = 0.5;
          }
          {
            width = 1;
            height = 0.8;
            col = 1;
            row = 0;
          }
        ];
      };
    };
  };

  example = {
    plugins.lf = {
      enable = true;

      settings = {
        default_action = "drop";
        default_actions = {
          "<C-t>" = "tabedit";
          "<C-x>" = "split";
          "<C-v>" = "vsplit";
          "<C-o>" = "tab drop";
        };
        winblend = 10;
        dir = "";
        direction = "float";
        border = "rounded";
        height.__raw = "vim.fn.float2nr(vim.fn.round(0.75 * vim.o.lines))";
        width.__raw = "vim.fn.float2nr(vim.fn.round(0.75 * vim.o.columns))";
        escape_quit = true;
        focus_on_open = true;
        tmux = false;
        default_file_manager = true;
        disable_netrw_warning = true;
      };
    };
  };
}
