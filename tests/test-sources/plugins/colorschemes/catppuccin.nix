{
  # Empty configuration
  empty = {colorschemes.catppuccin.enable = true;};

  # All the upstream default options of poimandres
  defaults = {
    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";
      background = {
        light = "latte";
        dark = "mocha";
      };
      transparentBackground = false;
      terminalColors = true;
      showBufferEnd = false;
      dimInactive = {
        enabled = true;
        shade = "dark";
        percentage = 0.15;
      };
      disableItalic = true;
      disableBold = true;
      styles = {
        comments = ["italic"];
        conditionals = ["italic"];
        loops = [];
        functions = [];
        keywords = [];
        strings = [];
        variables = [];
        numbers = [];
        booleans = [];
        properties = [];
        types = [];
        operators = [];
      };
      colorOverrides = {};
      customHighlights = {};
      integrations = {
        cmp = true;
        gitsigns = true;
        nvimtree = true;
        telescope = true;
        notify = false;
        mini = false;
      };
    };
  };
}
