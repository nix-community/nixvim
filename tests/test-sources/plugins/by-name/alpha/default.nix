{
  theme = {
    plugins.alpha = {
      enable = true;
      theme = "dashboard";
    };
  };

  theme-lua = {
    plugins.alpha = {
      enable = true;
      theme.__raw = "require'alpha.themes.startify'.config";
    };
  };

  terminal = {
    plugins.alpha = {
      enable = true;
      layout = [
        {
          type = "terminal";
          command = "echo 'Welcome to Nixvim!'";
          width = 46;
          height = 25;
          opts = {
            redraw = true;
          };
        }
      ];
    };
  };

  custom-layout = {
    plugins.alpha = {
      enable = true;

      layout = [
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = [
            "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
            "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
            "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
            "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
            "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
            "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
          ];
          opts = {
            position = "center";
            hl = "Type";
          };
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "group";
          val = [
            {
              type = "button";
              val = "  New file";
              on_press.__raw = "function() vim.cmd[[ene]] end";
              opts.shortcut = "n";
            }
            {
              type = "button";
              val = " Quit Neovim";
              on_press.__raw = "function() vim.cmd[[qa]] end";
              opts.shortcut = "q";
            }
          ];
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = "Inspiring quote here.";
          opts = {
            position = "center";
            hl = "Keyword";
          };
        }
      ];
      opts = {
        margin = 0;
        noautocmd = true;

        keymap = {
          press = "<CR>";
          press_queue = "<M-CR>";
        };
      };
    };
  };

  no-icons = {
    plugins.web-devicons.enable = false;
    plugins.alpha = {
      enable = true;
      theme = "dashboard";
    };
  };
}
