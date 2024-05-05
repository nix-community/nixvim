{
  empty = {
    plugins.which-key.enable = true;
  };

  defaults = {
    plugins.which-key = {
      enable = true;

      # Testing for registrations
      registrations."f" = {
        prefix = "<leader>";
        mode = [
          "n"
          "v"
          "i"
          "t"
          "c"
          "x"
          "s"
          "o"
        ];
        name = "Group Test";
        f = "Label Test";
        "1" = [
          {
            __raw = ''
              function()
                print("Raw Lua Code and List KeyMapping Test")
              end
            '';
          }
          "Raw Lua Code and List KeyMapping Test"
        ];
        "oo" = "Label Test 2";
        "<tab>" = {
          name = "Group in Group Test";
          f = [
            {
              __raw = ''
                function()
                  vim.cmd("echo 'Raw Lua Code and List KeyMapping Test 2'")
                end
              '';
            }

            "Raw Lua Code and List KeyMapping Test 2"
          ];
        };
      };

      plugins = {
        marks = true;
        registers = true;
        spelling = {
          enabled = true;
          suggestions = 20;
        };
        presets = {
          operators = true;
          motions = true;
          textObjects = true;
          windows = true;
          nav = true;
          z = true;
          g = true;
        };
      };

      operators = {
        gc = "Comments";
      };
      keyLabels = {};

      motions = {
        count = true;
      };

      icons = {
        breadcrumb = "»";
        separator = "➜";
        group = "+";
      };

      popupMappings = {
        scrollDown = "<c-d>";
        scrollUp = "<c-u>";
      };

      window = {
        border = "none";
        position = "bottom";
        margin = {
          top = 1;
          right = 0;
          bottom = 1;
          left = 0;
        };
        padding = {
          top = 1;
          right = 2;
          bottom = 1;
          left = 2;
        };
        winblend = 0;
      };
      layout = {
        height = {
          min = 4;
          max = 25;
        };
        width = {
          min = 20;
          max = 50;
        };
        spacing = 3;
        align = "left";
      };
      ignoreMissing = false;
      hidden = [
        "<silent>"
        "<cmd>"
        "<Cmd>"
        "<CR>"
        "^:"
        "^ "
        "^call "
        "^lua "
      ];
      showHelp = true;
      showKeys = true;
      triggers = "auto";
      triggersNoWait = [
        "`"
        "'"
        "g`"
        "g'"
        ''"''
        "<c-r>"
        "z="
      ];
      triggersBlackList = {
        i = [
          "j"
          "k"
        ];
        v = [
          "j"
          "k"
        ];
      };
      disable = {
        buftypes = [];
        filetypes = [];
      };
    };
  };
}
