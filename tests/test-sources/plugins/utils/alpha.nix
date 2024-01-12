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

  custom-layout = {
    plugins.alpha = {
      enable = true;

      iconsEnabled = true;
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
              shortcut = "e";
              desc = "  New file";
              command = "<CMD>ene <CR>";
            }
            {
              shortcut = "SPC q";
              desc = "  Quit Neovim";
              command = ":qa<CR>";
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
}
