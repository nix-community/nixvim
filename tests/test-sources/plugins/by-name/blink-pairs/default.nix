{
  empty = {
    plugins.blink-pairs.enable = true;
  };

  defaults = {
    plugins.blink-pairs = {
      enable = true;
      settings = {
        mappings = {
          enabled = true;
          cmdline = true;
          disabled_filetypes = [ ];
          pairs = [ ];
        };
        highlights = {
          enabled = true;
          cmdline = true;
          groups = [
            "BlinkPairsOrange"
            "BlinkPairsPurple"
            "BlinkPairsBlue"
          ];
          unmatched_group = "BlinkPairsUnmatched";
          matchparen = {
            enabled = true;
            cmdline = false;
            include_surrounding = false;
            group = "BlinkPairsMatchParen";
            priority = 250;
          };
        };
        debug = false;
      };
    };
  };

  example = {
    plugins.blink-pairs = {
      enable = true;

      settings = {
        mappings.enabled = false;
        highlights = {
          enabled = true;
          cmdline = true;
          groups = [
            "rainbow1"
            "rainbow2"
            "rainbow3"
            "rainbow4"
            "rainbow5"
            "rainbow6"
          ];
          unmatched_group = "";
          matchparen = {
            enabled = true;
            cmdline = false;
            include_surrounding = false;
            group = "BlinkPairsMatchParen";
            priority = 250;
          };
        };
      };
    };
  };
}
