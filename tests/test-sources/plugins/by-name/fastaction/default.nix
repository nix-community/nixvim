{
  empty = {
    plugins.fastaction.enable = true;
  };

  defaults = {
    plugins.fastaction = {
      enable = true;

      settings = {
        popup = {
          title = "Select one of:";
          relative = "cursor";
          border = "rounded";
          hide_cursor = true;
          highlight = {
            divider = "FloatBorder";
            key = "MoreMsg";
            title = "Title";
            window = "NormalFloat";
          };
          x_offset = 0;
          y_offset = 0;
        };
        priority.default = [ ];
        register_ui_select = false;
        keys = "qwertyuiopasdfghlzxcvbnm";
        dismiss_keys = [
          "j"
          "k"
          "<c-c>"
          "q"
        ];
        override_function.__raw = "function(_) end";
        fallback_threshold = 26;
      };
    };
  };

  example = {
    plugins.fastaction = {
      enable = true;

      settings = {
        dismiss_keys = [
          "j"
          "k"
          "<c-c>"
          "q"
        ];
        keys = "qwertyuiopasdfghlzxcvbnm";
        popup = {
          border = "rounded";
          hide_cursor = true;
          highlight = {
            divider = "FloatBorder";
            key = "MoreMsg";
            title = "Title";
            window = "NormalFloat";
          };
          title = "Select one of:";
        };
        priority.dart = [
          {
            pattern = "organize import";
            key = "o";
            order = 1;
          }
          {
            pattern = "extract method";
            key = "x";
            order = 2;
          }
          {
            pattern = "extract widget";
            key = "e";
            order = 3;
          }
        ];
        register_ui_select = false;
      };
    };
  };
}
