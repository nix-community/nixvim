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
          log_file = null;
          log_level = null;
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
          log_file = null;
          log_level = null;
          user = false;
        };
        network = {
          private = false;
          timeout = {
            max = 15000;
            interval = 256;
          };
          windows_pipe = null;
          unix_socket = null;
        };
        servers = {
          "*" = {
            connect.default = { };
            cwd = null;
            launch.default = { };
            lsp = { };
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
