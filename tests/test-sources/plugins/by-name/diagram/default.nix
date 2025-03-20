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
            background = null;
            theme = null;
            scale = 1;
            width = null;
            height = null;
          };
          plantuml = {
            charset = null;
          };
          d2 = {
            theme_id = null;
            dark_theme_id = null;
            scale = null;
            layout = null;
            sketch = null;
          };
          gnuplot = {
            size = null;
            font = null;
            theme = null;
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
