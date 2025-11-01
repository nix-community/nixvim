{
  empty = {
    plugins.sniprun.enable = true;
  };

  default = {
    plugins.sniprun = {
      enable = true;

      settings = {
        selected_interpreters.__empty = { };
        repl_enable.__empty = { };
        repl_disable.__empty = { };
        interpreter_options.__empty = { };
        display = [
          "Classic"
          "VirtualTextOk"
        ];
        live_display = [ "VirtualTextOk" ];
        display_options = {
          terminal_scrollback.__raw = "vim.o.scrollback";
          terminal_line_number = false;
          terminal_signcolumn = false;
          terminal_position = "vertical";
          terminal_width = 45;
          terminal_height = 20;
          notification_timeout = 5;
        };
        show_no_output = [
          "Classic"
          "TempFloatingWindow"
        ];
        snipruncolors = {
          SniprunVirtualTextOk = {
            bg = "#66eeff";
            fg = "#000000";
            ctermbg = "Cyan";
            ctermfg = "Black";
          };
          SniprunFloatingWinOk = {
            fg = "#66eeff";
            ctermfg = "Cyan";
          };
          SniprunVirtualTextErr = {
            bg = "#881515";
            fg = "#000000";
            ctermbg = "DarkRed";
            ctermfg = "Black";
          };
          SniprunFloatingWinErr = {
            fg = "#881515";
            ctermfg = "DarkRed";
            bold = true;
          };
        };
        live_mode_toggle = "off";
        inline_messages = false;
        borders = "single";
      };
    };
  };
}
