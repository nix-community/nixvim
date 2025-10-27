{
  empty = {
    plugins.which-key.enable = true;
  };

  defaults = {
    plugins.which-key = {
      enable = true;

      settings = {
        preset = "classic";

        delay.__raw = ''
          function(ctx)
            return ctx.plugin and 0 or 200
          end
        '';

        filter.__raw = ''
          function(mapping)
              return true
            end
        '';

        spec.__empty = { };

        notify = true;

        triggers = [
          {
            __unkeyed = "<auto>";
            mode = "nsxot";
          }
        ];

        defer.__raw = ''
          function(ctx)
            return ctx.mode == "V" or ctx.mode == "<C-V>"
          end
        '';

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
            text_objects = true;
            windows = true;
            nav = true;
            z = true;
            g = true;
          };
        };

        win = {
          no_overlap = true;

          padding = [
            1
            2
          ];

          title = true;
          title_pos = "center";
          zindex = 1000;
          bo.__empty = { };
          wo.__empty = { };
        };

        layout = {
          width = {
            min = 20;
          };
          spacing = 3;
        };

        keys = {
          scroll_down = "<c-d>";
          scroll_up = "<c-u>";
        };

        sort = [
          "local"
          "order"
          "group"
          "alphanum"
          "mod"
        ];

        expand = 0;

        replace = {
          key = [
            {
              __raw = ''
                function(key)
                  return require("which-key.view").format(key)
                end
              '';
            }
          ];

          desc = [
            [
              "<Plug>%(?(.*)%)?"
              "%1"
            ]
            [
              "^%+"
              ""
            ]
            [
              "<[cC]md>"
              ""
            ]
            [
              "<[cC][rR]>"
              ""
            ]
            [
              "<[sS]ilent>"
              ""
            ]
            [
              "^lua%s+"
              ""
            ]
            [
              "^call%s+"
              ""
            ]
            [
              "^:%s*"
              ""
            ]
          ];
        };

        icons = {
          breadcrumb = "»";
          separator = "➜";
          group = "+";
          ellipsis = "…";
          mappings = true;
          rules.__empty = { };
          colors = true;
          keys = {
            Up = " ";
            Down = " ";
            Left = " ";
            Right = " ";
            C = "󰘴 ";
            M = "󰘵 ";
            D = "󰘳 ";
            S = "󰘶 ";
            CR = "󰌑 ";
            Esc = "󱊷 ";
            ScrollWheelDown = "󱕐 ";
            ScrollWheelUp = "󱕑 ";
            NL = "󰌑 ";
            BS = "󰁮";
            Space = "󱁐 ";
            Tab = "󰌒 ";
            F1 = "󱊫";
            F2 = "󱊬";
            F3 = "󱊭";
            F4 = "󱊮";
            F5 = "󱊯";
            F6 = "󱊰";
            F7 = "󱊱";
            F8 = "󱊲";
            F9 = "󱊳";
            F10 = "󱊴";
            F11 = "󱊵";
            F12 = "󱊶";
          };
        };

        show_help = true;
        show_keys = true;

        disable = {
          bt.__empty = { };
          ft.__empty = { };
        };

        debug = false;
      };
    };
  };

  # Testing for registrations
  mappings = {
    plugins.which-key = {
      enable = true;
      settings = {
        spec =
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
            # Nested mapping
            {
              mode = [
                "n"
                "v"
              ];
              __unkeyed-1 = [
                {
                  __unkeyed-1 = "<leader>f";
                  group = "Group Test";
                }
                {
                  __unkeyed-1 = "<leader>f<tab>";
                  group = "Group in Group Test";
                }
              ];
            }
            # Create mapping
            {
              __unkeyed-1 = "<leader>cS";
              __unkeyed-2 = "<cmd>CodeSnapSave<CR>";
              mode = "v";
              desc = "Save";
            }
            # Function mapping
            {
              __unkeyed-1 = "<leader>db";
              __unkeyed-2.__raw = ''
                function()
                  require("dap").toggle_breakpoint()
                end
              '';
              mode = "n";
              desc = "Breakpoint toggle";
              silent = true;
            }
          ];
      };
    };
  };
}
