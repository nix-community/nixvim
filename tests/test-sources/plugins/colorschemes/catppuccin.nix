{
  # Empty configuration
  empty = {
    colorschemes.catppuccin.enable = true;
  };

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
        telescope = {
          enabled = true;
        };
        notify = false;
        mini = {
          enabled = false;
        };
      };
    };
  };

  example = {
    colorschemes.catppuccin = {
      enable = true;

      flavour = "mocha";
      terminalColors = true;
      colorOverrides.mocha.base = "#1e1e2f";

      integrations = {
        barbar = true;
        fidget = true;
        gitsigns = true;
        illuminate = {
          enabled = true;
        };
        indent_blankline = {
          enabled = true;
          colored_indent_levels = true;
        };
        lsp_trouble = true;
        mini = {
          enabled = true;
        };
        native_lsp.enabled = true;
        navic.enabled = true;
        nvimtree = true;
        overseer = true;
        telescope = {
          enabled = true;
          style = "nvchad";
        };
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
