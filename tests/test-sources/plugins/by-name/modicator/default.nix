{
  empty = {
    plugins.modicator.enable = true;
  };

  default = {
    plugins.modicator = {
      enable = true;

      settings = {
        show_warnings = false;
        highlights = {
          defaults = {
            bold = false;
            italic = false;
          };
          use_cursorline_background = false;
        };
        integration = {
          lualine = {
            enabled = true;
            mode_section.__raw = "nil";
            highlight = "bg";
          };
        };
      };
    };
  };

  example = {
    plugins.modicator = {
      enable = true;

      settings = {
        show_warnings = true;
        highlights = {
          defaults = {
            bold = false;
            italic = false;
          };
        };
      };
    };
  };
}
