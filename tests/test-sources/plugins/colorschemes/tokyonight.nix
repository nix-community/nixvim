{
  # Empty configuration
  empty = {
    colorschemes.tokyonight.enable = true;
  };

  # All the upstream default options of tokyonight
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
      # Not implemented
      # onColors = {__raw = "function(colors) end";};
      # Not implemented
      # onHighlights = {__raw = "function(colors) end";};
    };
  };
}
