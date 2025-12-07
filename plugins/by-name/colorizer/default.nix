{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "colorizer";
  package = "nvim-colorizer-lua";
  description = "A high-performance color highlighter for Neovim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions =
    let
      colorizerOptions = {
        names = defaultNullOpts.mkBool true ''
          Whether to highlight name codes like `Blue` or `blue`.
        '';

        RGB = defaultNullOpts.mkBool true ''
          Whether to highlight `#RGB` hex codes.
        '';

        RRGGBB = defaultNullOpts.mkBool true ''
          Whether to highlight `#RRGGBB` hex codes.
        '';

        RRGGBBAA = defaultNullOpts.mkBool false ''
          Whether to highlight `#RRGGBBAA` hex codes.
        '';

        AARRGGBB = defaultNullOpts.mkBool false ''
          Whether to highlight `0xAARRGGBB` hex codes.
        '';

        rgb_fn = defaultNullOpts.mkBool false ''
          Whether to highlight CSS `rgb()` and `rgba()` functions.
        '';

        hsl_fn = defaultNullOpts.mkBool false ''
          Whether to highlight CSS `hsl()` and `hsla()` functions.
        '';

        css = defaultNullOpts.mkBool false ''
          Enable all CSS features: `rgb_fn`, `hsl_fn`, `names`, `RGB`, `RRGGBB`.
        '';

        css_fn = defaultNullOpts.mkBool false ''
          Enable all CSS *functions*: `rgb_fn`, `hsl_fn`.
        '';

        mode =
          defaultNullOpts.mkEnum
            [
              "foreground"
              "background"
              "virtualtext"
            ]
            "background"
            ''
              Set the display mode.
            '';

        tailwind =
          defaultNullOpts.mkNullable
            (
              with types;
              either bool (enum [
                "normal"
                "lsp"
                "both"
              ])
            )
            false
            ''
              Enable tailwind colors.
              It can be a boolean, `"normal"`, `"lsp"` or `"both"`.
              `true` is same as `"normal"`.
            '';

        sass = {
          enable = defaultNullOpts.mkBool false ''
            Enable sass colors.
          '';

          parsers = defaultNullOpts.mkListOf types.str [ "css" ] ''
            Parsers can contain values used in `user_default_options`.
          '';
        };

        virtualtext = defaultNullOpts.mkStr "■" ''
          Virtualtext character to use.
        '';

        virtualtext_inline = defaultNullOpts.mkBool false ''
          Display virtualtext inline with color.
        '';

        virtualtext_mode = defaultNullOpts.mkEnum [ "background" "foreground" ] "foreground" ''
          Virtualtext highlight mode.
        '';

        always_update = defaultNullOpts.mkBool false ''
          Update color values even if buffer is not focused.
          Example use: `cmp_menu`, `cmp_docs`.
        '';
      };
    in
    {
      filetypes = defaultNullOpts.mkNullable' {
        type =
          with types;
          either (attrsOf (
            either str (submodule {
              freeformType = attrsOf anything;
              options = colorizerOptions;
            })
          )) (listOf str);
        pluginDefault = [ ];
        description = ''
          Per-filetype options.
        '';
        example = {
          __unkeyed-1 = "css";
          __unkeyed-2 = "javascript";
          html = {
            mode = "background";
          };
        };
      };

      user_default_options = colorizerOptions;

      buftypes = defaultNullOpts.mkNullable' {
        type =
          with types;
          either (attrsOf (
            either str (submodule {
              freeformType = attrsOf anything;
              options = colorizerOptions;
            })
          )) (listOf str);
        pluginDefault = [ ];
        description = ''
          Per-buftype options.
          Buftype value is fetched by `vim.bo.buftype`.
        '';
        example = [
          "*"
          "!prompt"
          "!popup"
        ];
      };

      user_commands = defaultNullOpts.mkNullable' {
        type = with types; either bool (listOf str);
        pluginDefault = true;
        description = ''
          Enable all or some usercommands.
        '';
      };
    };

  settingsExample = {
    filetypes = {
      __unkeyed-1 = "*";
      __unkeyed-2 = "!vim";
      css.rgb_fn = true;
      html.names = false;
    };
    user_default_options = {
      mode = "virtualtext";
      names = false;
      virtualtext = "■ ";
    };
    user_commands = [
      "ColorizerToggle"
      "ColorizerReloadAllBuffers"
    ];
  };
}
