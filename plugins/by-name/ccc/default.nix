{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "ccc";
  originalName = "ccc.nvim";
  package = "ccc-nvim";

  maintainers = [ lib.maintainers.JanKremer ];

  settingsOptions =
    let
      listOfRawLua = with types; listOf strLua;
      mapToRawLua = map lib.nixvim.mkRaw;
    in
    {
      default_color = defaultNullOpts.mkStr "#000000" ''
        The default color used when a color cannot be picked. It must be HEX format.
      '';

      inputs = lib.mkOption {
        type = listOfRawLua;
        apply = mapToRawLua;
        default = [ ];
        example = [
          "ccc.input.rgb"
          "ccc.input.hsl"
          "ccc.input.hwb"
          "ccc.input.lab"
          "ccc.input.lch"
          "ccc.input.oklab"
          "ccc.input.oklch"
          "ccc.input.cmyk"
          "ccc.input.hsluv"
          "ccc.input.okhsl"
          "ccc.input.hsv"
          "ccc.input.okhsv"
          "ccc.input.xyz"
        ];
        description = ''
          List of color system to be activated.
          `ccc-action-toggle_input_mode` toggles in this order.
          The first one is the default used at the first startup.
          Once activated, it will keep the previous input mode.

          Plugin default:
          ```nix
            [
              "ccc.input.rgb"
              "ccc.input.hsl"
              "ccc.input.cmyk"
            ]
          ```
        '';
      };

      outputs = lib.mkOption {
        type = listOfRawLua;
        apply = mapToRawLua;
        default = [ ];
        example = [
          "ccc.output.hex"
          "ccc.output.hex_short"
          "ccc.output.css_rgb"
          "ccc.output.css_hsl"
          "ccc.output.css_hwb"
          "ccc.output.css_lab"
          "ccc.output.css_lch"
          "ccc.output.css_oklab"
          "ccc.output.css_oklch"
          "ccc.output.float"
          "ccc.output.hex.setup({ uppercase = true })"
          "ccc.output.hex_short.setup({ uppercase = true })"
        ];
        description = ''
          List of output format to be activated.
          `ccc-action-toggle_ouotput_mode` toggles in this order.
          The first one is the default used at the first startup.
          Once activated, it will keep the previous output mode.

          Plugin default:
          ```nix
            [
              "ccc.output.hex"
              "ccc.output.hex_short"
              "ccc.output.css_rgb"
              "ccc.output.css_hsl"
            ]
          ```
        '';
      };

      pickers = lib.mkOption {
        type = listOfRawLua;
        apply = mapToRawLua;
        default = [ ];
        example = [
          "ccc.picker.hex"
          "ccc.picker.css_rgb"
          "ccc.picker.css_hsl"
          "ccc.picker.css_hwb"
          "ccc.picker.css_lab"
          "ccc.picker.css_lch"
          "ccc.picker.css_oklab"
          "ccc.picker.css_oklch"
          "ccc.picker.css_name"
        ];
        description = ''
          List of formats that can be detected by `:CccPick` to be activated.

          Plugin default:
          ```nix
            [
              "ccc.picker.hex"
              "ccc.picker.css_rgb"
              "ccc.picker.css_hsl"
              "ccc.picker.css_hwb"
              "ccc.picker.css_lab"
              "ccc.picker.css_lch"
              "ccc.picker.css_oklab"
              "ccc.picker.css_oklch"
            ]
          ```
        '';
      };

      highlight_mode =
        defaultNullOpts.mkEnumFirstDefault
          [
            "bg"
            "fg"
            "background"
            "foreground"
          ]
          ''
            Option to highlight text foreground or background.
            It is used to `output_line` and `highlighter`.
          '';

      lsp = defaultNullOpts.mkBool true ''
        Whether to enable LSP support.
        The color information is updated in the background and the result is used by `:CccPick` and
        highlighter.
      '';

      highlighter = {
        auto_enable = defaultNullOpts.mkBool false ''
          Whether to enable automatically on `BufEnter`.
        '';

        filetypes = defaultNullOpts.mkListOf types.str [ ] ''
          File types for which highlighting is enabled.
          It is only used for automatic highlighting by `ccc-option-highlighter-auto-enable`, and is
          ignored for manual activation.
          An empty table means all file types.
        '';

        excludes = defaultNullOpts.mkListOf types.str [ ] ''
          Used only when `ccc-option-highlighter-filetypes` is empty table.
          You can specify file types to be excludes.
        '';

        lsp = defaultNullOpts.mkBool true ''
          If true, highlight using LSP.
          If language server with the color provider is not attached to a buffer, it falls back to
          highlight with pickers.
          See also `:help ccc-option-lsp`.
        '';

        update_insert = defaultNullOpts.mkBool true ''
          If true, highlights will be updated during insert mode.
          If false, highlights will not be updated during editing in insert mode, but will be
          updated on `InsertLeave`.
        '';
      };

      convert = lib.mkOption {
        type =
          with types;
          nullOr (
            maybeRaw (
              listOf
                # Pairs of lua strings
                (listOf strLua)
            )
          );
        apply = builtins.map mapToRawLua;
        default = [ ];
        example = [
          [
            "ccc.picker.hex"
            "ccc.output.css_oklch"
          ]
          [
            "ccc.picker.css_oklch"
            "ccc.output.hex"
          ]
        ];
        description = ''
          Specify the correspondence between picker and output.
          The default setting converts the color to `css_rgb` if it is in hex format, to `css_hsl`
          if it is in `css_rgb` format, and to hex if it is in `css_hsl` format.

          Plugin default:
          ```nix
            [
              ["ccc.picker.hex" "ccc.output.css_rgb"]
              ["ccc.picker.css_rgb" "ccc.output.css_hsl"]
              ["ccc.picker.css_hsl" "ccc.output.hex"]
            ]
          ```
        '';
      };
    };

  settingsExample = {
    default_color = "#FFFFFF";
    inputs = [
      "ccc.input.oklab"
      "ccc.input.oklch"
    ];
    outputs = [
      "ccc.output.css_oklab"
      "ccc.output.css_oklch"
    ];
    pickers = [
      "ccc.picker.css_oklch"
      "ccc.picker.css_name"
      "ccc.picker.hex"
    ];
    highlight_mode = "fg";
    lsp = false;
    highlighter = {
      auto_enable = true;
      lsp = false;
      excludes = [ "markdown" ];
      update_insert = false;
    };
  };

  callSetup = false;
  extraConfig = cfg: {
    # ccc requires `termguicolors` to be enabled.
    opts.termguicolors = lib.mkDefault true;

    plugins.ccc.luaConfig.content = ''
      ccc = require('ccc')
      ccc.setup(${lib.nixvim.toLuaObject cfg.settings})
    '';
  };
}
