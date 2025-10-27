{
  empty = {
    plugins.twilight.enable = true;
  };

  defaults = {
    plugins = {
      treesitter.enable = true;
      twilight = {
        enable = true;

        settings = {
          dimming = {
            alpha = 0.25;
            color = [
              "Normal"
              "#ffffff"
            ];
            term_bg = "#000000";
            inactive = false;
          };
          context = 10;
          treesitter = true;
          expand = [
            "function"
            "method"
            "table"
            "if_statement"
          ];
          exclude.__empty = { };
        };
      };
    };
  };
}
