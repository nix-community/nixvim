{
  lib,
  helpers,
  pkgs,
  config,
  ...
}:
with lib;
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "rose-pine";
    isColorscheme = true;
    defaultPackage = pkgs.vimPlugins.rose-pine;

    maintainers = [maintainers.GaetanLepage];

    # TODO introduced 2024-04-15: remove 2024-06-15
    optionsRenamedToSettings = [
      "groups"
      "highlightGroups"
    ];
    imports = let
      basePluginPath = ["colorschemes" "rose-pine"];
    in [
      (
        mkRenamedOptionModule
        (basePluginPath ++ ["style"])
        (basePluginPath ++ ["settings" "dark_variant"])
      )
      (
        mkRenamedOptionModule
        (basePluginPath ++ ["dimInactive"])
        (basePluginPath ++ ["settings" "dim_inactive_windows"])
      )
      (
        mkRemovedOptionModule
        (basePluginPath ++ ["disableItalics"])
        "Use `colorschemes.rose-pine.settings.enable.italics` instead."
      )
      (
        mkRemovedOptionModule
        (basePluginPath ++ ["boldVerticalSplit"])
        "Use `colorschemes.rose-pine.settings.highlight_groups` instead."
      )
      (
        mkRemovedOptionModule
        (basePluginPath ++ ["transparentFloat"])
        "Use `colorschemes.rose-pine.settings.highlight_groups.NormalFloat` instead."
      )
      (
        mkRenamedOptionModule
        (basePluginPath ++ ["transparentBackground"])
        (basePluginPath ++ ["settings" "enable" "transparency"])
      )
    ];

    settingsOptions = {
      variant = helpers.mkNullOrOption (types.enum ["auto" "main" "moon" "dawn"]) ''
        Set the desired variant: "auto" will follow the vim background, defaulting to `dark_variant`
        or "main" for dark and "dawn" for light.
      '';

      dark_variant = helpers.defaultNullOpts.mkEnumFirstDefault ["main" "moon" "dawn"] ''
        Set the desired dark variant when `settings.variant` is set to "auto".
      '';

      dim_inactive_windows = helpers.defaultNullOpts.mkBool false ''
        Differentiate between active and inactive windows and panels.
      '';

      extend_background_behind_borders = helpers.defaultNullOpts.mkBool true ''
        Extend background behind borders.
        Appearance differs based on which border characters you are using.
      '';

      enable = {
        legacy_highlights = helpers.defaultNullOpts.mkBool true "Enable legacy highlights.";

        migrations = helpers.defaultNullOpts.mkBool true "Enable migrations.";

        terminal = helpers.defaultNullOpts.mkBool true "Enable terminal.";
      };

      styles = {
        bold = helpers.defaultNullOpts.mkBool true "Enable bold.";

        italic = helpers.defaultNullOpts.mkBool true "Enable italic.";

        transparency = helpers.defaultNullOpts.mkBool true "Enable transparency.";
      };

      groups = helpers.mkNullOrOption (with types; attrsOf (either str (attrsOf str))) ''
        Highlight groups.

        default: see [source](https://github.com/rose-pine/neovim/blob/main/lua/rose-pine/config.lua)
      '';

      highlight_groups = helpers.defaultNullOpts.mkAttrsOf helpers.nixvimTypes.highlight "{}" ''
        Custom highlight groups.
      '';

      before_highlight = helpers.defaultNullOpts.mkLuaFn "function(group, highlight, palette) end" ''
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
      highlight_groups = {};
      before_highlight = "function(group, highlight, palette) end";
    };

    extraConfig = cfg: {
      opts.termguicolors = mkDefault true;
    };
  }
