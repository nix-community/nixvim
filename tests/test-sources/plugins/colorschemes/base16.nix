{
  empty = {
    colorschemes.base16.enable = true;
  };

  defaults = {
    colorschemes.base16 = {
      enable = true;

      colorscheme = "schemer-dark";
      setUpBar = true;

      settings = {
        telescope = true;
        telescope_borders = false;
        indentblankline = true;
        notify = true;
        ts_rainbow = true;
        cmp = true;
        illuminate = true;
        lsp_semantic = true;
        mini_completion = true;
        dapui = true;
      };
    };
  };

  builtin-colorscheme = {
    colorschemes.base16 = {
      enable = true;

      colorscheme = "gruvbox-dark-hard";
      setUpBar = false;
    };
  };

  custom-colors = {
    colorschemes.base16 = {
      enable = true;

      colorscheme = {
        base00 = "#16161D";
        base01 = "#2c313c";
        base02 = "#3e4451";
        base03 = "#6c7891";
        base04 = "#565c64";
        base05 = "#abb2bf";
        base06 = "#9a9bb3";
        base07 = "#c5c8e6";
        base08 = "#e06c75";
        base09 = "#d19a66";
        base0A = "#e5c07b";
        base0B = "#98c379";
        base0C = "#56b6c2";
        base0D = "#0184bc";
        base0E = "#c678dd";
        base0F = "#a06949";
      };
    };
  };
}
