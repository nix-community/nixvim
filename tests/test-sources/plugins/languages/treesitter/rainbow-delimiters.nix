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

        strategy = {
          default = "global";
          html = "local";
          latex.__raw = ''
            function()
              -- Disabled for very large files, global strategy for large files,
              -- local strategy otherwise
              if vim.fn.line('$') > 10000 then
                  return nil
              elseif vim.fn.line('$') > 1000 then
                  return rainbow.strategy['global']
              end
              return rainbow.strategy['local']
            end
          '';
        };
        query = {
          default = "rainbow-delimiters";
          lua = "rainbow-blocks";
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
        blacklist = ["c" "cpp"];
        log = {
          file.__raw = "vim.fn.stdpath('log') .. '/rainbow-delimiters.log'";
          level = "warn";
        };
      };
    };
  };

  example-whitelist = {
    plugins = {
      treesitter.enable = true;
      rainbow-delimiters = {
        enable = true;

        whitelist = ["c" "cpp"];
      };
    };
  };
}
