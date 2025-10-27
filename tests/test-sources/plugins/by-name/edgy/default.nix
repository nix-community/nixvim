{
  empty = {
    plugins.edgy.enable = true;
  };

  defaults = {
    plugins.edgy = {
      enable = true;

      settings = {
        left.__empty = { };
        bottom.__empty = { };
        right.__empty = { };
        top.__empty = { };
        options = {
          left = {
            size = 30;
            wo.__raw = "nil";
          };
          bottom = {
            size = 10;
            wo.__raw = "nil";
          };
          right = {
            size = 30;
            wo.__raw = "nil";
          };
          top = {
            size = 10;
            wo.__raw = "nil";
          };
        };
        animate = {
          enabled = true;
          fps = 100;
          cps = 120;
          on_begin = ''
            function()
              vim.g.minianimate_disable = true
            end
          '';
          on_end = ''
            function()
              vim.g.minianimate_disable = false
            end
          '';
          spinner = {
            frames = [
              "⠋"
              "⠙"
              "⠹"
              "⠸"
              "⠼"
              "⠴"
              "⠦"
              "⠧"
              "⠇"
              "⠏"
            ];
            interval = 80;
          };
        };
        exit_when_last = false;
        close_when_all_hidden = true;
        wo = {
          winbar = true;
          winfixwidth = true;
          winfixheight = false;
          winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal";
          spell = false;
          signcolumn = "no";
        };
        keys = {
          q = ''
            function(win)
              win:close()
            end
          '';
          "<c-q>" = ''
            function(win)
              win:hide()
            end
          '';
          Q = ''
            function(win)
              win.view.edgebar:close()
            end
          '';
          "]w" = ''
            function(win)
              win:next({ visible = true, focus = true })
            end
          '';
          "[w" = ''
            function(win)
              win:prev({ visible = true, focus = true })
            end
          '';
          "]W" = ''
            function(win)
              win:next({ pinned = false, focus = true })
            end
          '';
          "[W" = ''
            function(win)
              win:prev({ pinned = false, focus = true })
            end
          '';
          "<c-w>>" = ''
            function(win)
              win:resize("width", 2)
            end
          '';
          "<c-w><lt>" = ''
            function(win)
              win:resize("width", -2)
            end
          '';
          "<c-w>+" = ''
            function(win)
              win:resize("height", 2)
            end
          '';
          "<c-w>-" = ''
            function(win)
              win:resize("height", -2)
            end
          '';
          "<c-w>=" = ''
            function(win)
              win.view.edgebar:equalize()
            end
          '';
        };
        icons = {
          closed = " ";
          open = " ";
        };
      };
    };
  };

  example = {
    plugins.edgy = {
      enable = true;

      settings = {
        animate.enabled = false;
        wo = {
          winbar = false;
          winfixwidth = false;
          winfixheight = false;
          winhighlight = "";
          spell = false;
          signcolumn = "no";
        };
        bottom = [
          {
            ft = "toggleterm";
            size = 30;
            filter = ''
              function(buf, win)
                return vim.api.nvim_win_get_config(win).relative == ""
              end
            '';
          }
          {
            ft = "help";
            size = 20;
            filter = ''
              function(buf)
                return vim.bo[buf].buftype == "help"
              end
            '';
          }
        ];
        left = [
          {
            title = "nvimtree";
            ft = "NvimTree";
            size = 30;
          }
          {
            ft = "Outline";
            open = "SymbolsOutline";
          }
          { ft = "dapui_scopes"; }
          { ft = "dapui_breakpoints"; }
          { ft = "dap-repl"; }
        ];
      };
    };
  };
}
