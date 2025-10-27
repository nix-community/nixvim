{
  empty = {
    # image.nvim/lua/image/utils/term.lua:34: Failed to get terminal size
    test.runNvim = false;

    plugins.diagram.enable = true;
  };

  defaults = {
    # image.nvim/lua/image/utils/term.lua:34: Failed to get terminal size
    test.runNvim = false;

    plugins.diagram = {
      enable = true;

      settings = {
        renderer_options = {
          mermaid = {
            background.__raw = "nil";
            theme.__raw = "nil";
            scale = 1;
            width.__raw = "nil";
            height.__raw = "nil";
          };
          plantuml = {
            charset.__raw = "nil";
          };
          d2 = {
            theme_id.__raw = "nil";
            dark_theme_id.__raw = "nil";
            scale.__raw = "nil";
            layout.__raw = "nil";
            sketch.__raw = "nil";
          };
          gnuplot = {
            size.__raw = "nil";
            font.__raw = "nil";
            theme.__raw = "nil";
          };
        };
      };
    };
  };

  example = {
    # image.nvim/lua/image/utils/term.lua:34: Failed to get terminal size
    test.runNvim = false;

    plugins.diagram = {
      enable = true;

      settings = {
        integrations = [
          { __raw = "require('diagram.integrations.markdown')"; }
          { __raw = "require('diagram.integrations.neorg')"; }
        ];
        renderer_options = {
          mermaid = {
            theme = "forest";
          };
          plantuml = {
            charset = "utf-8";
          };
          d2 = {
            theme_id = 1;
          };
          gnuplot = {
            theme = "dark";
            size = "800,600";
          };
        };
      };
    };
  };
}
