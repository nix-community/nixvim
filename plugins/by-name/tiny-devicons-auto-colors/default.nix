{ config, lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "tiny-devicons-auto-colors";
  packPathName = "tiny-devicons-auto-colors.nvim";
  package = "tiny-devicons-auto-colors-nvim";
  description = "A Neovim plugin that automatically assigns colors to devicons based on their nearest color in a predefined color palette.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    colors =
      defaultNullOpts.mkNullableWithRaw (with lib.types; either (attrsOf anything) (listOf str)) [ ]
        ''
          A table of color codes that the plugin will use to assign colors to devicons.
          If not provided, the plugin will fetch highlights from the current theme to generate a color palette.
        '';

    factors = {
      lightness = defaultNullOpts.mkNum 1.75 ''
        Adjust the lightness factor.
      '';
      chroma = defaultNullOpts.mkNum 1 ''
        Adjust the chroma factor.
      '';
      hue = defaultNullOpts.mkNum 1.25 ''
        Adjust the hue factor.
      '';
    };

    cache = {
      enabled = defaultNullOpts.mkBool true ''
        Enable or disable caching to improve performance.
      '';
      path = defaultNullOpts.mkStr (lib.nixvim.literalLua ''vim.fn.stdpath("cache") .. "/tiny-devicons-auto-colors-cache.json"'') ''
        Path to the cache file.
      '';
    };

    precise_search = {
      enabled = defaultNullOpts.mkBool true ''
        Enable or disable precise search for better color matching.
      '';
      iteration = defaultNullOpts.mkNum 10 ''
        Number of iterations for precise search.
      '';
      precision = defaultNullOpts.mkNum 20 ''
        Precision level for the search.
      '';
      threshold = defaultNullOpts.mkNum 23 ''
        Threshold to consider a color as a match.
      '';
    };

    ignore = defaultNullOpts.mkListOf lib.types.str [ ] ''
      A list of icon names to ignore.
    '';

    autoreload = defaultNullOpts.mkBool false ''
      Automatically reload colors when the colorscheme changes.
    '';
  };

  settingsExample = {
    colors = {
      red = "#ff0000";
      green = "#00ff00";
    };
    factors = {
      lightness = 1.5;
      chroma = 1.2;
      hue = 1.1;
    };
    cache = {
      enabled = true;
      path = "/path/to/cache.json";
    };
    precise_search = {
      enabled = true;
      iteration = 15;
      precision = 25;
      threshold = 20;
    };
    ignore = [
      "lua"
      "vim"
    ];
    autoreload = true;
  };

  extraConfig = {
    assertions = lib.nixvim.mkAssertions "plugins.tiny-devicons-auto-colors" {
      assertion =
        config.plugins.web-devicons.enable
        || (
          config.plugins.mini.enable
          && config.plugins.mini.modules ? icons
          && config.plugins.mini.mockDevIcons
        );
      message = ''
        Either `plugins.web-devicons` or `plugins.mini`* must be enabled to use `tiny-devicons-auto-colors`.
        *If using `plugins.mini`, you must enable the `icons` module and the `mockDevIcons` option.
      '';
    };
  };
}
