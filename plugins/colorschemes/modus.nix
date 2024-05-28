{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "modus";
  luaName = "modus-themes";
  originalName = "modus-themes.nvim";
  defaultPackage = pkgs.vimPlugins.modus-themes-nvim;
  isColorscheme = true;

  maintainers = [ helpers.maintainers.nwjsmith ];

  settingsOptions = {
    style =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "modus_operandi"
          "modus_vivendi"
        ]
        ''
          The theme comes in a light `modus_operandi` style and a dark `modus_vivendi` style.
        '';

    variant =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "default"
          "tinted"
          "deuteranopia"
          "tritanopia"
        ]
        ''
          Styles come in four variants:

          - `default` is the plugin's main style designed to cover a broad range of needs.
          - `tinted` tones down intensity and provides more color variety.
          - `deuteranopia` is optimized for users with red-green color deficiency.
          - `tritanopia` is optimized for users with blue-yellow color deficiency.
        '';

    transparent = helpers.defaultNullOpts.mkBool false ''
      Disable setting the background color.
    '';

    dim_inactive = helpers.defaultNullOpts.mkBool false ''
      Dims inactive windows.
    '';

    styles = {
      comments = helpers.defaultNullOpts.mkHighlight "{italic = true;}" "" ''
        Define comments highlight properties.
      '';

      keywords = helpers.defaultNullOpts.mkHighlight "{italic = true;}" "" ''
        Define keywords highlight properties.
      '';

      functions = helpers.defaultNullOpts.mkHighlight "{}" "" ''
        Define functions highlight properties.
      '';

      variables = helpers.defaultNullOpts.mkHighlight "{}" "" ''
        Define variables highlight properties.
      '';
    };

    on_colors = helpers.defaultNullOpts.mkLuaFn "function(colors) end" ''
      Override specific color groups to use other groups or a hex color.
      Function will be called with a `ColorScheme` table.

      ```
      @param colors ColorScheme
      ```
    '';

    on_highlights = helpers.defaultNullOpts.mkLuaFn "function(highlights, colors) end" ''
      Override specific highlights to use other groups or a hex color.
      Function will be called with a `Highlights` and `ColorScheme` table.

      ```
      @param highlights Highlights
      @param colors ColorScheme
      ```
    '';
  };

  settingsExample = {
    style = "auto";
    variant = "default";
    transparent = false;
    dim_inactive = false;
    styles = {
      comments.italic = true;
      keywords.italic = true;
      functions = { };
      variables = { };
    };
    on_colors = "function(colors) end";
    on_highlights = "function(highlights, colors) end";
  };

  extraConfig = cfg: { opts.termguicolors = lib.mkDefault true; };
}
