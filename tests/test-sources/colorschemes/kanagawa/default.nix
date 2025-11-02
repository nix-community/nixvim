{
  empty = {
    colorschemes.kanagawa.enable = true;
  };

  defaults = {
    colorschemes.kanagawa = {
      enable = true;

      settings = {
        compile = false;
        undercurl = true;
        commentStyle = {
          italic = true;
        };
        functionStyle.__empty = { };
        keywordStyle = {
          italic = true;
        };
        statementStyle = {
          bold = true;
        };
        typeStyle.__empty = { };
        transparent = false;
        dimInactive = false;
        terminalColors = true;
        colors = {
          theme = {
            wave = {
              ui = {
                float = {
                  bg = "none";
                };
              };
            };
            dragon = {
              syn = {
                parameter = "yellow";
              };
            };
            all = {
              ui = {
                bg_gutter = "none";
              };
            };
          };
          palette = {
            sumiInk0 = "#000000";
            fujiWhite = "#FFFFFF";
          };
        };
        overrides = ''
          function(colors)
            return {}
          end
        '';
        theme = "wave";
        background = {
          light = "lotus";
          dark = "wave";
        };
      };
    };
  };
}
