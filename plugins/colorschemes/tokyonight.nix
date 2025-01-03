{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "tokyonight";
  isColorscheme = true;
  packPathName = "tokyonight.nvim";
  package = "tokyonight-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO introduced 2024-04-15: remove 2024-06-15
  optionsRenamedToSettings = [
    "style"
    "transparent"
    "terminalColors"
    [
      "styles"
      "comments"
    ]
    [
      "styles"
      "keywords"
    ]
    [
      "styles"
      "functions"
    ]
    [
      "styles"
      "variables"
    ]
    [
      "styles"
      "sidebars"
    ]
    [
      "styles"
      "floats"
    ]
    "sidebars"
    "dayBrightness"
    "hideInactiveStatusline"
    "dimInactive"
    "lualineBold"
    "onColors"
    "onHighlights"
  ];

  settingsOptions = {
    style =
      defaultNullOpts.mkEnumFirstDefault
        [
          "moon"
          "storm"
          "night"
          "day"
        ]
        ''
          The theme comes in four styles, `moon`, `storm`, a darker variant `night`, and `day`.
        '';

    light_style = defaultNullOpts.mkStr "day" ''
      The theme to use when the background is set to `light`.
    '';

    transparent = defaultNullOpts.mkBool false ''
      Disable setting the background color.
    '';

    terminal_colors = defaultNullOpts.mkBool true ''
      Configure the colors used when opening a :terminal in Neovim
    '';

    styles =
      let
        mkBackgroundStyle =
          name:
          defaultNullOpts.mkEnumFirstDefault [
            "dark"
            "transparent"
            "normal"
          ] "Background style for ${name}";
      in
      {
        comments = defaultNullOpts.mkHighlight { italic = true; } "" ''
          Define comments highlight properties.
        '';

        keywords = defaultNullOpts.mkHighlight { italic = true; } "" ''
          Define keywords highlight properties.
        '';

        functions = defaultNullOpts.mkHighlight { } "" ''
          Define functions highlight properties.
        '';

        variables = defaultNullOpts.mkHighlight { } "" ''
          Define variables highlight properties.
        '';

        sidebars = mkBackgroundStyle "sidebars";

        floats = mkBackgroundStyle "floats";
      };

    sidebars =
      defaultNullOpts.mkListOf lib.types.str
        [
          "qf"
          "help"
        ]
        ''
          Set a darker background on sidebar-like windows.
        '';

    day_brightness = defaultNullOpts.mkProportion 0.3 ''
      Adjusts the brightness of the colors of the **Day** style.
      Number between 0 and 1, from dull to vibrant colors.
    '';

    hide_inactive_statusline = defaultNullOpts.mkBool false ''
      Enabling this option will hide inactive statuslines and replace them with a thin border instead.
      Should work with the standard **StatusLine** and **LuaLine**.
    '';

    dim_inactive = defaultNullOpts.mkBool false ''
      Dims inactive windows.
    '';

    lualine_bold = defaultNullOpts.mkBool false ''
      When true, section headers in the lualine theme will be bold.
    '';

    on_colors = defaultNullOpts.mkLuaFn "function(colors) end" ''
      Override specific color groups to use other groups or a hex color.
      Function will be called with a `ColorScheme` table.
      `@param colors ColorScheme`
    '';

    on_highlights = defaultNullOpts.mkLuaFn "function(highlights, colors) end" ''
      Override specific highlights to use other groups or a hex color.
      Function will be called with a `Highlights` and `ColorScheme` table.
      `@param highlights Highlights`
      `@param colors ColorScheme`
    '';
  };

  settingsExample = {
    style = "storm";
    light_style = "day";
    transparent = false;
    terminal_colors = true;
    styles = {
      comments.italic = true;
      keywords.italic = true;
      functions = { };
      variables = { };
      sidebars = "dark";
      floats = "dark";
    };
    sidebars = [
      "qf"
      "vista_kind"
      "terminal"
      "packer"
    ];
    day_brightness = 0.3;
    hide_inactive_statusline = false;
    dim_inactive = false;
    lualine_bold = false;
    on_colors = "function(colors) end";
    on_highlights = "function(highlights, colors) end";
  };

  extraConfig = {
    opts.termguicolors = lib.mkDefault true;
  };
}
