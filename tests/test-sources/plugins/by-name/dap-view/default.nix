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
          headers = {
            breakpoints = "Breakpoints [B]";
            scopes = "Scopes [S]";
            exceptions = "Exceptions [E]";
            watches = "Watches [W]";
            threads = "Threads [T]";
            repl = "REPL [R]";
            console = "Console [C]";
          };
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
            icons = {
              pause = "";
              play = "";
              step_into = "";
              step_over = "";
              step_out = "";
              step_back = "";
              run_last = "";
              terminate = "";
              disconnect = "";
            };
            custom_buttons = { };
          };
        };
        windows = {
          height = 12;
          terminal = {
            position = "left";
            hide = { };
            start_hidden = false;
          };
        };
        switchbuf = "usetab;newtab";
      };
    };
  };
}
