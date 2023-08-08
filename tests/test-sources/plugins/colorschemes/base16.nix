{
  # Empty configuration
  empty = {
    colorschemes.base16.enable = true;
  };

  # All the upstream default options of poimandres
  defaults = {
    colorschemes.base16 = {
      enable = true;

      useTruecolor = true;
      colorscheme = "gruvbox-dark-hard";
      setUpBar = true;
      customColorScheme = null;
    };
  };

  custom-colors = {
    colorschemes.base16 = {
      enable = true;

      customColorScheme = {
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
