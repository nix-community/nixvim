{
  empty = {
    plugins.neoscroll.enable = true;
  };

  example = {
    plugins.neoscroll = {
      enable = true;
      settings = {
        mappings = [
          "<C-u>"
          "<C-d>"
          "<C-b>"
          "<C-f>"
          "<C-y>"
          "<C-e>"
          "zt"
          "zz"
          "zb"
        ];
        hide_cursor = true;
        stop_eof = true;
        respect_scrolloff = false;
        cursor_scrolls_alone = true;
        easing_function = "quadratic";
        pre_hook = ''
          function(info)
            if info == "cursorline" then
              vim.wo.cursorline = false
            end
          end
        '';
        post_hook = ''
          function(info)
            if info == "cursorline" then
              vim.wo.cursorline = true
            end
          end
        '';
      };
    };
  };

  defaults = {
    plugins.neoscroll = {
      enable = true;
      settings = {
        mappings = [
          "<C-u>"
          "<C-d>"
          "<C-b>"
          "<C-f>"
          "<C-y>"
          "<C-e>"
          "zt"
          "zz"
          "zb"
        ];
        hide_cursor = true;
        step_eof = true;
        respect_scrolloff = false;
        cursor_scrolls_alone = true;
        easing_function.__raw = "nil";
        pre_hook.__raw = "nil";
        post_hook.__raw = "nil";
        performance_mode = false;
      };
    };
  };
}
