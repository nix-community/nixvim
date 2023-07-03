{
  empty = {
    plugins.dap.extensions.dap-ui.enable = true;
  };

  default = {
    plugins.dap.extensions.dap-ui = {
      enable = true;

      controls = {
        element = "repl";
        enabled = true;
        icons = {
          disconnect = "";
          pause = "";
          play = "";
          run_last = "";
          step_back = "";
          step_into = "";
          step_out = "";
          step_over = "";
          terminate = "";
        };
      };
      elementMappings = {};
      expandLines = true;
      floating = {
        border = "single";
        mappings = {
          close = ["q" "<Esc>"];
        };
      };
      forceBuffers = true;
      icons = {
        collapsed = "";
        current_frame = "";
        expanded = "";
      };
      layouts = [
        {
          elements = [
            {
              id = "scopes";
              size = 0.25;
            }
            {
              id = "breakpoints";
              size = 0.25;
            }
            {
              id = "stacks";
              size = 0.25;
            }
            {
              id = "watches";
              size = 0.25;
            }
          ];
          position = "left";
          size = 40;
        }
        {
          elements = [
            {
              id = "repl";
              size = 0.5;
            }
            {
              id = "console";
              size = 0.5;
            }
          ];
          position = "bottom";
          size = 10;
        }
      ];
      mappings = {
        edit = "e";
        expand = ["<CR>" "<2-LeftMouse>"];
        open = "o";
        remove = "d";
        repl = "r";
        toggle = "t";
      };
      render = {
        indent = 1;
        maxValueLines = 100;
      };
    };
  };
}
