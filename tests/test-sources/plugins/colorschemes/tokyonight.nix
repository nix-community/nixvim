{
  empty = {
    colorschemes.tokyonight.enable = true;
  };

  defaults = {
    colorschemes.tokyonight = {
      enable = true;

      style = "storm";
      # Not implemented
      # lightStyle = "day";
      transparent = false;
      terminalColors = true;
      styles = {
        comments = {italic = true;};
        keywords = {italic = true;};
        functions = {};
        variables = {};
        sidebars = "dark";
        floats = "dark";
      };
      sidebars = ["qf" "help"];
      dayBrightness = 0.3;
      hideInactiveStatusline = false;
      dimInactive = false;
      lualineBold = false;
      onColors = "function(colors) end";
      onHighlights = "function(highlights, colors) end";
    };
  };
}
