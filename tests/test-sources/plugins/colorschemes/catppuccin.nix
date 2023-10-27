{
  # Empty configuration
  empty = {
    colorschemes.catppuccin.enable = true;
  };

  # All the upstream default options of catppuccin
  defaults = {
    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";
      background = {
        light = "latte";
        dark = "mocha";
      };
      transparentBackground = false;
      terminalColors = false;
      showBufferEnd = false;
      dimInactive = {
        enabled = true;
        shade = "dark";
        percentage = 0.15;
      };
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

  example = {
    colorschemes.catppuccin = {
      enable = true;

      flavour = "mocha";
      terminalColors = true;
      colorOverrides.mocha.base = "#1e1e2f";

      disableItalic = true;
      disableBold = true;
      disableUnderline = true;

      integrations = {
        barbar = true;
        fidget = true;
        gitsigns = true;
        illuminate = true;
        indent_blankline = {
          enabled = true;
          colored_indent_levels = true;
        };
        lsp_trouble = true;
        mini = true;
        native_lsp.enabled = true;
        navic.enabled = true;
        nvimtree = true;
        overseer = true;
        telescope = true;
        treesitter = true;
        treesitter_context = true;
        ts_rainbow2 = true;
      };
      styles = {
        booleans = ["bold" "italic"];
        conditionals = ["bold"];
        functions = ["bold"];
        keywords = ["italic"];
        loops = ["bold"];
        operators = ["bold"];
        properties = ["italic"];
      };
    };
  };
}
