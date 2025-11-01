{
  empty = {
    plugins.dashboard = {
      enable = true;
    };
  };

  defaults = {
    plugins.dashboard = {
      enable = true;

      settings = {
        theme = "hyper";
        disable_move = false;
        shortcut_type = "letter";
        buffer_name = "Dashboard";
        change_to_vcs_root = false;

        config = {
          disable_move = false;

          week_header = {
            enable = false;
            concat = "";
            append.__empty = { };
          };
          header = [
            ""
            " ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗  █████╗ ██████╗ ██████╗  "
            " ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗ "
            " ██║  ██║███████║███████╗███████║██████╔╝██║   ██║███████║██████╔╝██║  ██║ "
            " ██║  ██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██╔══██║██╔══██╗██║  ██║ "
            " ██████╔╝██║  ██║███████║██║  ██║██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝ "
            " ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  "
            ""
          ];
        };

        hide = {
          statusline = true;
          tabline = true;
        };

        preview = {
          command = "";
          file_path.__raw = "nil";
          file_height = 0;
          file_width = 0;
        };
      };
    };
  };

  hyper_options = {
    plugins.dashboard = {
      enable = true;

      settings = {
        theme = "hyper";

        config = {
          packages.enable = true;

          shortcut = [
            {
              desc = "string";
              group = "highlight group";
              key = "shortcut key";
              action = "action when you press key";
            }
          ];

          project = {
            enable = true;
            limit = 8;
            icon = "your icon";
            label = "";
            action = "Telescope find_files cwd=";
          };

          mru = {
            limit = 10;
            icon = "your icon";
            label = "";
            cwd_only = false;
          };

          footer.__empty = { };
        };
      };
    };
  };

  doom_options = {
    plugins.dashboard = {
      enable = true;

      settings = {
        theme = "hyper";

        config = {
          center = [
            {
              icon = "";
              icon_hl = "group";
              desc = "description";
              desc_hl = "group";
              key = "shortcut key in dashboard buffer not keymap !!";
              key_hl = "group";
              key_format = " [%s]";
              action = "";
            }
          ];
          footer.__empty = { };
        };
      };
    };
  };

  hyper_example = {
    plugins.dashboard = {
      enable = true;

      settings = {
        theme = "hyper";
        change_to_vcs_root = true;

        config = {
          week_header.enable = true;
          project.enable = false;
          mru.limit = 20;

          header = [
            "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
            "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
            "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
            "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
            "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
            "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
          ];

          shortcut = [
            {
              icon = " ";
              icon_hl = "@variable";
              desc = "Files";
              group = "Label";
              action.__raw = "function(path) vim.cmd('Telescope find_files') end";
              key = "f";
            }
            {
              desc = " Apps";
              group = "DiagnosticHint";
              action = "Telescope app";
              key = "a";
            }
            {
              desc = " dotfiles";
              group = "Number";
              action = "Telescope dotfiles";
              key = "d";
            }
          ];

          footer = [ "Made with ❤️" ];
        };
      };
    };
  };

  doom_example = {
    plugins.dashboard = {
      enable = true;

      settings = {
        theme = "doom";

        config = {
          header = [ "Your header" ];
          center = [
            {
              icon = " ";
              icon_hl = "Title";
              desc = "Find File           ";
              desc_hl = "String";
              key = "b";
              keymap = "SPC f f";
              key_hl = "Number";
              key_format = " %s";
              action = "lua print(2)";
            }
            {
              icon = " ";
              desc = "Find Dotfiles";
              key = "f";
              keymap = "SPC f d";
              key_format = " %s";
              action.__raw = "function() print(3) end";
            }
          ];
          footer = [ "Your footer" ];
        };
      };
    };
  };

  header-raw = {
    plugins.dashboard = {
      enable = true;

      settings.config.header.__raw = ''
        function()
          return {
              "",
              " ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗  █████╗ ██████╗ ██████╗  ",
              " ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗ ",
              " ██║  ██║███████║███████╗███████║██████╔╝██║   ██║███████║██████╔╝██║  ██║ ",
              " ██║  ██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██╔══██║██╔══██╗██║  ██║ ",
              " ██████╔╝██║  ██║███████║██║  ██║██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝ ",
              " ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ",
              ""
          }
        end
      '';
    };
  };

  header-line-raw = {
    plugins.dashboard = {
      enable = true;

      settings.config.header = [
        {
          __raw = ''
            function()
              return {
                  "",
                  " ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗  █████╗ ██████╗ ██████╗  ",
                  " ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗ ",
                  " ██║  ██║███████║███████╗███████║██████╔╝██║   ██║███████║██████╔╝██║  ██║ ",
                  " ██║  ██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██╔══██║██╔══██╗██║  ██║ ",
                  " ██████╔╝██║  ██║███████║██║  ██║██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝ ",
                  " ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ",
                  ""
              }
            end
          '';
        }
      ];
    };
  };
}
