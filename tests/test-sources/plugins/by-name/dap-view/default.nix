{
  empty = {
    plugins.dap-view.enable = true;
  };

  defaults = {
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
              short_label = " [B]";
              action.__raw = ''
                function()
                    require("dap-view.views").switch_to_view("breakpoints")
                end
              '';
            };
            scopes = {
              keymap = "S";
              label = "Scopes [S]";
              short_label = "󰂥 [S]";
              action.__raw = ''
                function()
                  require("dap-view.views").switch_to_view("scopes")
                end
              '';
            };
            exceptions = {
              keymap = "E";
              label = "Exceptions [E]";
              short_label = "󰢃 [E]";
              action.__raw = ''
                function()
                    require("dap-view.views").switch_to_view("exceptions")
                end
              '';
            };
            watches = {
              keymap = "W";
              label = "Watches [W]";
              short_label = "󰛐 [W]";
              action.__raw = ''
                function()
                  require("dap-view.views").switch_to_view("watches")
                end
              '';
            };
            threads = {
              keymap = "T";
              label = "Threads [T]";
              short_label = "󱉯 [T]";
              action.__raw = ''
                function()
                  require("dap-view.views").switch_to_view("threads")
                end
              '';
            };
            repl = {
              keymap = "R";
              label = "REPL [R]";
              short_label = "󰯃 [R]";
              action.__raw = ''
                function()
                  require("dap-view.repl").show()
                end
              '';
            };
            sessions = {
              keymap = "K";
              label = "Sessions [K]";
              short_label = " [K]";
              action.__raw = ''
                function()
                  require("dap-view.views").switch_to_view("sessions")
                end
              '';
            };
            console = {
              keymap = "C";
              label = "Console [C]";
              short_label = "󰆍 [C]";
              action.__raw = ''
                function()
                  require("dap-view.term").show()
                end
              '';
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
          height = 0.25;
          position = "below";
          terminal = {
            width = 0.5;
            position = "left";
            hide.__empty = { };
            start_hidden = false;
          };
        };
        icons = {
          disabled = "";
          disconnect = "";
          enabled = "";
          filter = "󰈲";
          negate = " ";
          pause = "";
          play = "";
          run_last = "";
          step_back = "";
          step_into = "";
          step_out = "";
          step_over = "";
          terminate = "";
        };
        help = {
          border.__raw = "nil";
        };
        switchbuf = "usetab";
        auto_toggle = false;
        follow_tab = false;
      };
    };
  };

  example = {
    plugins.dap-view = {
      enable = true;

      settings = {
        winbar = {
          controls.enabled = true;
        };
        windows.terminal = {
          position = "right";
          start_hidden = true;
        };
      };
    };
  };
}
