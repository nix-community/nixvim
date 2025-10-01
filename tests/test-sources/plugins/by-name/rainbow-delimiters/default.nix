{
  empty = {
    plugins = {
      treesitter.enable = true;
      rainbow-delimiters.enable = true;
    };
  };

  example = {
    plugins = {
      treesitter.enable = true;
      rainbow-delimiters = {
        enable = true;
        settings = {
          settingsExample = {
            blacklist = [ "json" ];
            strategy = {
              "".__raw = "require 'rainbow-delimiters'.strategy['global']";
              "nix".__raw = "require 'rainbow-delimiters'.strategy['local']";
            };
            highlight = [
              "RainbowDelimiterViolet"
              "RainbowDelimiterBlue"
              "RainbowDelimiterGreen"
            ];
          };
        };
      };
    };
  };

  defaults = {
    plugins = {
      treesitter.enable = true;
      rainbow-delimiters = {
        enable = true;
        settings = {
          query = {
            "" = "rainbow-delimiters";
            javascript = "rainbow-delimiters-react";
          };
          strategy = {
            "".__raw = "require 'rainbow-delimiters'.strategy['global']";
          };
          priority = {
            "".__raw =
              "math.floor(((vim.hl or vim.highlight).priorities.semantic_tokens + (vim.hl or vim.highlight).priorities.treesitter) / 2)";
          };
          log = {
            level.__raw = "vim.log.levels.WARN";
            file.__raw = "vim.fn.stdpath('log') .. '/rainbow-delimiters.log'";
          };
          highlight = [
            "RainbowDelimiterRed"
            "RainbowDelimiterYellow"
            "RainbowDelimiterBlue"
            "RainbowDelimiterOrange"
            "RainbowDelimiterGreen"
            "RainbowDelimiterViolet"
            "RainbowDelimiterCyan"
          ];

        };
      };
    };
  };
}
