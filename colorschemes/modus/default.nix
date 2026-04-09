{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "modus";
  moduleName = "modus-themes";
  package = "modus-themes-nvim";
  isColorscheme = true;

  maintainers = [ lib.maintainers.nwjsmith ];

  settingsOptions = {
    style =
      defaultNullOpts.mkEnumFirstDefault
        [
          "modus_operandi"
          "modus_vivendi"
        ]
        ''
          The theme comes in a light `modus_operandi` style and a dark `modus_vivendi` style.
        '';

    variants = {
      modus_operandi =
        defaultNullOpts.mkEnumFirstDefault
          [
            "default"
            "tinted"
            "deuteranopia"
            "tritanopia"
          ]
          ''
            Variant to use for the `modus_operandi` style.
          '';

      modus_vivendi =
        defaultNullOpts.mkEnumFirstDefault
          [
            "default"
            "tinted"
            "deuteranopia"
            "tritanopia"
          ]
          ''
            Variant to use for the `modus_vivendi` style.
          '';
    };

    transparent = defaultNullOpts.mkBool false ''
      Disable setting the background color.
    '';

    hide_inactive_statusline = defaultNullOpts.mkBool false ''
      Hide statuslines in inactive windows.
    '';

    dim_inactive = defaultNullOpts.mkBool false ''
      Dims inactive windows.
    '';

    styles = {
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
    };

    on_colors = defaultNullOpts.mkLuaFn "function(colors) end" ''
      Override specific color groups to use other groups or a hex color.
      Function will be called with a `ColorScheme` table.

      ```
      @param colors ColorScheme
      ```
    '';

    on_highlights = defaultNullOpts.mkLuaFn "function(highlights, colors) end" ''
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
    variants = {
      modus_operandi = "default";
      modus_vivendi = "default";
    };
    transparent = false;
    dim_inactive = false;
    hide_inactive_statusline = false;
    styles = {
      comments.italic = true;
      keywords.italic = true;
      functions = { };
      variables = { };
    };
    on_colors = "function(colors) end";
    on_highlights = "function(highlights, colors) end";
  };

  extraConfig = {
    opts.termguicolors = lib.mkDefault true;
  };
}
