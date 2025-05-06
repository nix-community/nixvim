{
  empty = {
    plugins.hunk.enable = true;
  };

  with-web-devicons = {
    plugins.hunk.enable = true;
    plugins.web-devicons.enable = true;
  };

  with-mini = {
    plugins.hunk.enable = true;
    plugins.mini = {
      enable = true;
      modules.icons = { };
    };
  };

  example.plugins.hunk = {
    enable = true;
    settings = {
      keys.global.quit = [ "x" ];

      ui = {
        tree = {
          mode = "flat";
          width = 40;
        };
        layout = "horizontal";
      };

      hooks = {
        on_tree_mount.__raw = "function(_context) end";
        on_diff_mount.__raw = "function(_context) end";
      };
    };
  };

  # Taken directly from the plugin docs: https://github.com/julienvincent/hunk.nvim#configuration
  defaults.plugins.hunk = {
    enable = true;
    settings = {
      keys = {
        global = {
          quit = [ "q" ];
          accept = [ "<leader><Cr>" ];
          focus_tree = [ "<leader>e" ];
        };

        tree = {
          expand_node = [
            "l"
            "<Right>"
          ];
          collapse_node = [
            "h"
            "<Left>"
          ];

          open_file = [ "<Cr>" ];

          toggle_file = [ "a" ];
        };

        diff = {
          toggle_line = [ "a" ];
          toggle_hunk = [ "A" ];
        };
      };

      ui = {
        tree = {
          mode = "nested";
          width = 35;
        };
        layout = "vertical";
      };

      icons = {
        selected = "󰡖";
        deselected = "";
        partially_selected = "󰛲";

        folder_open = "";
        folder_closed = "";
      };

      hooks = {
        on_tree_mount.__raw = "function(_context) end";
        on_diff_mount.__raw = "function(_context) end";
      };
    };
  };
}
