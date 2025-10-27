{
  empty = {
    plugins.distant.enable = true;
  };

  defaults = {
    plugins.distant = {
      enable = true;

      settings = {
        buffer = {
          watch = {
            enabled = true;
            retry_timeout = 5000;
          };
        };
        client = {
          bin.__raw = ''
            (function()
              local os_name = require('distant-core').utils.detect_os_arch()
              return os_name == 'windows' and 'distant.exe' or 'distant'
            end)()
          '';
          log_file.__raw = "nil";
          log_level.__raw = "nil";
        };
        keymap = {
          dir = {
            enabled = true;
            copy = "C";
            edit = "<Return>";
            tabedit = "<C-t>";
            metadata = "M";
            newdir = "K";
            newfile = "N";
            rename = "R";
            remove = "D";
            up = "-";
          };
          file = {
            enabled = true;
            up = "-";
          };
          ui = {
            exit = [
              "q"
              "<Esc>"
            ];
            main = {
              connections = {
                kill = "K";
                toggle_info = "I";
              };
              tabs = {
                goto_connections = "1";
                goto_system_info = "2";
                goto_help = "?";
                refresh = "R";
              };
            };
          };
        };
        manager = {
          daemon = false;
          lazy = true;
          log_file.__raw = "nil";
          log_level.__raw = "nil";
          user = false;
        };
        network = {
          private = false;
          timeout = {
            max = 15000;
            interval = 256;
          };
          windows_pipe.__raw = "nil";
          unix_socket.__raw = "nil";
        };
        servers = {
          "*" = {
            connect.default = { };
            cwd.__raw = "nil";
            launch.default = { };
            lsp.__empty = { };
          };
        };
      };
    };
  };

  example = {
    plugins.distant = {
      enable = true;

      settings = {
        "network.unix_socket" = "/tmp/distant.sock";
        servers."192.168.1.42" = {
          default = {
            username = "me";
            port = 11451;
          };
        };
      };
    };
  };
}
