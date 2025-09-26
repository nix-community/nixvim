{
  empty = {
    plugins.colorful-winsep.enable = true;
  };

  defaults = {
    plugins.colorful-winsep = {
      enable = true;
      settings = {
        border = "bold";
        excluded_ft = [
          "packer"
          "TelescopePrompt"
          "mason"
        ];
        highlight.__raw = "nil";
        animate = {
          enabled = "shift";
          shift = {
            delta_time = 0.1;
            smooth_speed = 1;
            delay = 3;
          };
          progressive = {
            vertical_delay = 20;
            horizontal_delay = 2;
          };
        };
        indicator_for_2wins = {
          position = "center";
          symbols = {
            start_left = "󱞬";
            end_left = "󱞪";
            start_down = "󱞾";
            end_down = "󱟀";
            start_up = "󱞢";
            end_up = "󱞤";
            start_right = "󱞨";
            end_right = "󱞦";
          };
        };
      };
    };
  };

  example = {
    plugins.colorful-winsep = {
      enable = true;
      settings = {
        highlight = "#b8bb26";
        excluded_ft = [ "NvimTree" ];
        border = [
          "━"
          "┃"
          "┏"
          "┓"
          "┗"
          "┛"
        ];
      };
    };
  };
}
