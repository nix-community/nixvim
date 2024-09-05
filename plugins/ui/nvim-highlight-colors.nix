{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:

let
  inherit (helpers.defaultNullOpts)
    mkBool
    mkEnum
    mkListOf
    mkStr
    mkStr'
    ;
in
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "nvim-highlight-colors";
  defaultPackage = pkgs.vimPlugins.nvim-highlight-colors;

  maintainers = [ helpers.maintainers.thubrecht ];

  settingsOptions = {
    render = mkEnum [
      "background"
      "foreground"
      "virtual"
    ] "background" "The render style used.";

    virtual_symbol = mkStr "■" "The virtual symbol to be used when the render method is set to `virtual`.";
    virtual_symbol_prefix = mkStr "" "The virtual symbol prefix.";
    virtual_symbol_suffix = mkStr " " "The virtual symbol suffix.";
    virtual_symbol_position =
      mkEnum
        [
          "inline"
          "eol"
          "eow"
        ]
        "inline"
        ''
          The position for the virtual symbol.

          - `inline` mimics VS Code style
          - `eol` stands for `end of column`, it is recommended to set the virtual symbol suffix to `""` when used
          - `eow` stands for `end of word`, it is recommended to set the virtual symbol prefix to `" "` and the suffix to `""` when used
        '';

    enable_hex = mkBool true "Highlight hex colors, e.g. `#ffbbff`.";
    enable_short_hex = mkBool true "Highlight short hex colors, e.g. `#cbf`.";
    enable_rgb = mkBool true "Highlight rgb colors, e.g. `rgb(0 0 0)`.";
    enable_hsl = mkBool true "Highlight hsl colors, e.g. `hsl(150deg 30% 40%)`.";
    enable_var_usage = mkBool true "Highlight CSS variables, e.g. `var(--testing-color)`.";
    enable_named_colors = mkBool true "Highlight named colors, e.g. `green`.";
    enable_tailwind = mkBool true "Highlight tailwind colors, e.g. `bg-blue-500`.";

    custom_colors =
      mkListOf
        (lib.types.submodule {
          options = {
            label = mkStr' {
              description = ''
                The text matched for this color. It must be properly escaped with `%` to adhere to `string.gmatch`.
              '';
            };
            color = mkStr' {
              description = ''
                The color used, in hex format.
              '';
            };
          };
        })
        [ ]
        ''
          A list of custom colors.
        '';

    exclude_filetypes = mkListOf lib.stypes.str [ ] "A list of filetypes to exclude from highlighting.";
    exclude_buftypes = mkListOf lib.stypes.str [ ] "A list of buftypes to exclude from highlighting.";
  };

  settingsExample = {
    custom_colors = [
      {
        label = "%-%-theme%-primary%-color";
        color = "#0f1219";
      }
      {
        label = "%-%-theme%-secondary%-color";
        color = "#5a5d64";
      }
    ];
    exclude_buftypes = [ "text" ];
  };
}
