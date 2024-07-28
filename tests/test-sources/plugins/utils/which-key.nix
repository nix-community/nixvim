{
  empty = {
    plugins.which-key.enable = true;
  };

  defaults = {
    plugins.which-key = {
      enable = true;

      # Testing for registrations
      settings.spec =
        let
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
        in
        [
          {
            __unkeyed-1 = "<leader>f";
            group = "Group Test";
            inherit mode;
          }
          {
            __unkeyed-1 = "<leader>ff";
            desc = "Label Test";
            inherit mode;
          }
          {
            __unkeyed-1 = "<leader>f1";
            __unkeyed-2.__raw = ''
              function()
                print("Raw Lua KeyMapping Test")
              end
            '';
            desc = "Raw Lua KeyMapping Test";
            inherit mode;
          }
          {
            __unkeyed-1 = "<leader>foo";
            desc = "Label Test 2";
            inherit mode;
          }
          {
            __unkeyed-1 = "<leader>f<tab>";
            group = "Group in Group Test";
            inherit mode;
          }
          {
            __unkeyed-1 = "<leader>f<tab>f";
            __unkeyed-2 = "<cmd>echo 'Vim cmd KeyMapping Test'<cr>";
            desc = "Vim cmd KeyMapping Test";
            inherit mode;
          }
        ];

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
      keyLabels = { };

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
        buftypes = [ ];
        filetypes = [ ];
      };
    };
  };
}
