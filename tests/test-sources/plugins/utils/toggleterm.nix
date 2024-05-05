{
  empty = {
    plugins.toggleterm.enable = true;
  };

  simple-example = {
    plugins.toggleterm = {
      enable = true;

      settings = {
        open_mapping = "[[<c-\>]]";
        direction = "float";
        float_opts = {
          border = "curved";
          width = 130;
          height = 30;
        };
      };
    };
  };

  example = {
    plugins.toggleterm = {
      enable = true;

      settings = {
        size = ''
          function(term)
            if term.direction == "horizontal" then
              return 15
            elseif term.direction == "vertical" then
              return vim.o.columns * 0.4
            end
          end
        '';
        open_mapping = "[[<c-\>]]";
        on_create = "function() end";
        on_open = "function() end";
        on_close = "function() end";
        on_stdout = "function() end";
        on_stderr = "function() end";
        on_exit = "function() end";
        hide_numbers = false;
        shade_filetypes = [ "" ];
        autochdir = true;
        highlights = {
          Normal.guibg = "#000000";
          NormalFloat.link = "#FFFFFF";
        };
        shade_terminals = true;
        shading_factor = -40;
        start_in_insert = false;
        insert_mappings = false;
        terminal_mappings = true;
        persist_size = false;
        persist_mode = false;
        direction = "tab";
        close_on_exit = false;
        shell = "bash";
        auto_scroll = false;
        float_opts = {
          border = "double";
          width = 30;
          height = 30;
          winblend = 5;
          zindex = 20;
        };
        winbar = {
          enabled = true;
          name_formatter = ''
            function(term)
              return term.name + "Test"
            end
          '';
        };
      };
    };
  };

  defaults = {
    plugins.toggleterm = {
      enable = true;

      settings = {
        size = 12;
        open_mapping = null;
        on_create = null;
        on_open = null;
        on_close = null;
        on_stdout = null;
        on_stderr = null;
        on_exit = null;
        hide_numbers = true;
        shade_filetypes = [ ];
        autochdir = false;
        highlights = {
          NormalFloat.link = "Normal";
          FloatBorder.link = "Normal";
          StatusLine.gui = "NONE";
          StatusLineNC = {
            cterm = "italic";
            gui = "NONE";
          };
        };
        shade_terminals = true;
        shading_factor = -30;
        start_in_insert = true;
        insert_mappings = true;
        terminal_mappings = true;
        persist_size = true;
        persist_mode = true;
        direction = "horizontal";
        close_on_exit = true;
        shell.__raw = "vim.o.shell";
        auto_scroll = true;
        float_opts = {
          border = null;
          width = null;
          height = null;
          row = null;
          col = null;
          winblend = 0;
          zindex = null;
          title_pos = "left";
        };
        winbar = {
          enabled = false;
          name_formatter = ''
            function(term)
              return term.name
            end
          '';
        };
      };
    };
  };
}
