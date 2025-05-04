{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "kanagawa-paper";
  isColorscheme = true;
  packPathName = "kanagawa-paper.nvim";
  package = "kanagawa-paper-nvim";

  description = ''
    You can select the theme in two ways:
    - Set `colorschemes.kanagawa-paper.settings.theme` AND explicitly unset `vim.o.background` (i.e. `opts.background = ""`).
    - Set `colorschemes.kanagawa-paper.settings.background` (the active theme will depend on the value of `vim.o.background`).
  '';

  maintainers = [ lib.maintainers.FKouhai ];

  settingsExample = {
    background = "dark";
    cache = false;
    colors = {
      palette = { };
      theme = {
        ink = { };
        canvas = { };
      };
    };

    undercurl = true;
    styles = {
      comments = {
        italic = true;
      };
      functions = {
        italic = true;
      };
      keywords = {
        italic = true;
      };
      statement_style = {
        bold = true;
      };
    };

    transparent = true;
    auto_plugins = false;
    dim_inactive = false;
    gutter = false;
    compile = false;
    overrides = lib.nixvim.nestedLiteralLua "function(colors) return {} end";
    terminal_colors = false;
    theme = "ink";
  };
}
