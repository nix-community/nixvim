{
  empty = {
    plugins.mini.enable = true;
  };

  allOfficialModules = {
    plugins.mini = {
      enable = true;

      modules = {
        ai = {
          custom_textobjects = null;
          mappings = {
            around = "a";
            inside = "i";
            around_next = "an";
            inside_next = "in";
            around_last = "al";
            inside_last = "il";
            goto_left = "g[";
            goto_right = "g]";
          };
          n_lines = 50;
          search_method = "cover_or_next";
          silent = false;
        };
        animate = { };
        base16 = {
          palette = {
            base00 = "#123456";
            base01 = "#123456";
            base02 = "#123456";
            base03 = "#123456";
            base04 = "#123456";
            base05 = "#123456";
            base06 = "#123456";
            base07 = "#123456";
            base08 = "#123456";
            base09 = "#123456";
            base0A = "#123456";
            base0B = "#123456";
            base0C = "#123456";
            base0D = "#123456";
            base0E = "#123456";
            base0F = "#123456";
          };
        };
        basics = { };
        bracketed = { };
        bufremove = { };
        colors = { };
        comment = { };
        completion = { };
        cursorword = { };
        doc = { };
        fuzzy = { };
        hipatterns = { };
        hues = {
          background = "#351721";
          foreground = "#cdc4c6";
        };
        icons = { };
        indentscope = { };
        jump = { };
        jump2d = { };
        map = { };
        misc = { };
        move = { };
        pairs = { };
        sessions = { };
        splitjoin = { };
        starter = { };
        statusline = { };
        surround = { };
        tabline = { };
        test = { };
        trailspace = { };
      };
    };
  };

  icons-mock = {
    plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules.icons = { };
    };
  };
}
