{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "onenord";
  isColorscheme = true;
  package = "onenord-nvim";

  maintainers = [ lib.maintainers.Che-0129 ];

  settingsExample = {
    theme = "dark";
    borders = true;
    fade_nc = false;

    styles = {
      comments = "NONE";
      strings = "NONE";
      keywords = "NONE";
      functions = "NONE";
      variables = "NONE";
      diagnostics = "underline";
    };

    disable = {
      background = false;
      float_background = false;
      cursorline = false;
      eob_lines = true;
    };

    inverse.match_paren = false;
    custom_highlights = {
      "@constructor" = {
        fg = "#5E81AC";
        style = "bold";
      };
    };
    custom_colors = {
      red = "#ffffff";
    };
  };
}
