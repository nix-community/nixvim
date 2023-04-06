{pkgs}: {
  empty = {
    plugins = {
      treesitter.enable = true;
      treesitter-rainbow.enable = true;
    };
  };

  default = {
    plugins = {
      treesitter.enable = true;
      treesitter-rainbow = {
        enable = true;

        disable = [];
        query = "rainbow-parens";
        strategy = "require('ts-rainbow').strategy.global";
        hlgroups = [
          "TSRainbowRed"
          "TSRainbowYellow"
          "TSRainbowBlue"
          "TSRainbowOrange"
          "TSRainbowGreen"
          "TSRainbowViolet"
          "TSRainbowCyan"
        ];
      };
    };
  };
}
