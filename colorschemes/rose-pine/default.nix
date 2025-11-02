{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "rose-pine";
  isColorscheme = true;

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    variant =
      lib.nixvim.mkNullOrOption
        (lib.types.enum [
          "auto"
          "main"
          "moon"
          "dawn"
        ])
        ''
          Set the desired variant: "auto" will follow the vim background, defaulting to `dark_variant`
          or "main" for dark and "dawn" for light.
        '';

    dark_variant =
      defaultNullOpts.mkEnumFirstDefault
        [
          "main"
          "moon"
          "dawn"
        ]
        ''
          Set the desired dark variant when `settings.variant` is set to "auto".
        '';

    dim_inactive_windows = defaultNullOpts.mkBool false ''
      Differentiate between active and inactive windows and panels.
    '';

    extend_background_behind_borders = defaultNullOpts.mkBool true ''
      Extend background behind borders.
      Appearance differs based on which border characters you are using.
    '';

    enable = {
      legacy_highlights = defaultNullOpts.mkBool true "Enable legacy highlights.";

      migrations = defaultNullOpts.mkBool true "Enable migrations.";

      terminal = defaultNullOpts.mkBool true "Enable terminal.";
    };

    styles = {
      bold = defaultNullOpts.mkBool true "Enable bold.";

      italic = defaultNullOpts.mkBool true "Enable italic.";

      transparency = defaultNullOpts.mkBool true "Enable transparency.";
    };

    groups = mkNullOrOption (with lib.types; attrsOf (either str (attrsOf str))) ''
      Highlight groups.

      default: see [source](https://github.com/rose-pine/neovim/blob/main/lua/rose-pine/config.lua)
    '';

    highlight_groups = defaultNullOpts.mkAttrsOf lib.types.highlight { } ''
      Custom highlight groups.
    '';

    before_highlight = defaultNullOpts.mkLuaFn "function(group, highlight, palette) end" ''
      Called before each highlight group, before setting the highlight.

      `function(group, highlight, palette)`

      ```lua
        @param group string
        @param highlight Highlight
        @param palette Palette
      ```
    '';
  };

  settingsExample = {
    variant = "auto";
    dark_variant = "moon";
    dim_inactive_windows = true;
    extend_background_behind_borders = true;
    enable = {
      legacy_highlights = false;
      migrations = true;
      terminal = false;
    };
    styles = {
      bold = false;
      italic = true;
      transparency = true;
    };
    groups = {
      border = "muted";
      link = "iris";
      panel = "surface";
    };
    highlight_groups = { };
    before_highlight = "function(group, highlight, palette) end";
  };

  extraConfig = {
    opts.termguicolors = lib.mkDefault true;
  };
}
