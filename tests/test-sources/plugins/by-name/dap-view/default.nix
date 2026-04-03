{
  empty = {
    plugins.dap.enable = true;
    plugins.dap-view.enable = true;
  };

  defaults = {
    plugins.dap.enable = true;
    plugins.dap-view = {
      enable = true;

      settings = {
        winbar = {
          show = true;
          sections = [
            "watches"
            "scopes"
            "exceptions"
            "breakpoints"
            "threads"
            "repl"
          ];
          default_section = "watches";
          base_sections = {
            breakpoints = {
              keymap = "B";
              label = "Breakpoints [B]";
            };
            scopes = {
              keymap = "S";
              label = "Scopes [S]";
            };
            exceptions = {
              keymap = "E";
              label = "Exceptions [E]";
            };
            watches = {
              keymap = "W";
              label = "Watches [W]";
            };
            threads = {
              keymap = "T";
              label = "Threads [T]";
            };
            repl = {
              keymap = "R";
              label = "REPL [R]";
            };
            sessions = {
              keymap = "K";
              label = "Sessions [K]";
            };
            console = {
              keymap = "C";
              label = "Console [C]";
            };
          };
          custom_sections.__empty = { };
          controls = {
            enabled = false;
            position = "right";
            buttons = [
              "play"
              "step_into"
              "step_over"
              "step_out"
              "step_back"
              "run_last"
              "terminate"
              "disconnect"
            ];
            custom_buttons.__empty = { };
          };
        };
        windows = {
          size = 0.25;
          position = "below";
          terminal = {
            size = 0.5;
            position = "left";
            hide.__empty = { };
          };
        };
        icons = {
          disabled = "";
          disconnect = "";
          enabled = "";
          filter = "󰈲";
          negate = " ";
          pause = "";
          play = "";
          run_last = "";
          step_back = "";
          step_into = "";
          step_out = "";
          step_over = "";
          terminate = "";
        };
        help = {
          border.__raw = "nil";
        };
        render = {
          sort_variables.__raw = "nil";
          threads = {
            format.__raw = ''
              function(name, lnum, path)
                return {
                  { part = name, separator = " " },
                  { part = path, hl = "FileName", separator = ":" },
                  { part = lnum, hl = "LineNumber" },
                }
              end
            '';
            align = false;
          };
          breakpoints = {
            format.__raw = ''
              function(line, lnum, path)
                return {
                  { part = path, hl = "FileName" },
                  { part = lnum, hl = "LineNumber" },
                  { part = line, hl = true },
                }
              end
            '';
            align = false;
          };
        };
        switchbuf = "usetab,uselast";
        auto_toggle = false;
        follow_tab = false;
      };
    };
  };

  example = {
    plugins.dap.enable = true;
    plugins.dap-view = {
      enable = true;

      settings = {
        winbar = {
          controls.enabled = true;
        };
        windows.terminal = {
          position = "right";
        };
      };
    };
  };
}
