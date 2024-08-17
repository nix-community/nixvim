{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  flavours = [
    "latte"
    "mocha"
    "frappe"
    "macchiato"
  ];
in
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "catppuccin";
  isColorscheme = true;
  defaultPackage = pkgs.vimPlugins.catppuccin-nvim;
  installPackage = false;
  callSetup = false;

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-27: remove 2024-05-27
  optionsRenamedToSettings = [
    "flavour"
    [
      "background"
      "light"
    ]
    [
      "background"
      "dark"
    ]
    "transparentBackground"
    [
      "dimInactive"
      "enabled"
    ]
    [
      "dimInactive"
      "shade"
    ]
    [
      "dimInactive"
      "percentage"
    ]
    [
      "styles"
      "comments"
    ]
    [
      "styles"
      "conditionals"
    ]
    [
      "styles"
      "loops"
    ]
    [
      "styles"
      "functions"
    ]
    [
      "styles"
      "keywords"
    ]
    [
      "styles"
      "strings"
    ]
    [
      "styles"
      "variables"
    ]
    [
      "styles"
      "numbers"
    ]
    [
      "styles"
      "booleans"
    ]
    [
      "styles"
      "properties"
    ]
    [
      "styles"
      "types"
    ]
    [
      "styles"
      "operators"
    ]
    "colorOverrides"
    "customHighlights"
    "integrations"
  ];
  imports =
    mapAttrsToList
      (
        old: new:
        mkRenamedOptionModule
          [
            "colorschemes"
            "catppuccin"
            old
          ]
          [
            "colorschemes"
            "catppuccin"
            "settings"
            new
          ]
      )
      {
        showBufferEnd = "show_end_of_buffer";
        terminalColors = "term_colors";
        disableItalic = "no_italic";
        disableBold = "no_bold";
        disableUnderline = "no_underline";
      };

  settingsOptions = {
    compile_path = helpers.defaultNullOpts.mkStr {
      __raw = "vim.fn.stdpath 'cache' .. '/catppuccin'";
    } "Set the compile cache directory.";

    flavour = helpers.mkNullOrOption (types.enum (flavours ++ [ "auto" ])) ''
      Theme flavour.
    '';

    background =
      let
        mkBackgroundStyle =
          name:
          helpers.defaultNullOpts.mkEnumFirstDefault flavours ''
            Background for `${name}` background.
          '';
      in
      {
        light = mkBackgroundStyle "light";

        dark = mkBackgroundStyle "dark";
      };

    transparent_background = helpers.defaultNullOpts.mkBool false ''
      Enable Transparent background.
    '';

    show_end_of_buffer = helpers.defaultNullOpts.mkBool false ''
      Show the '~' characters after the end of buffers.
    '';

    term_colors = helpers.defaultNullOpts.mkBool false ''
      Configure the colors used when opening a :terminal in Neovim.
    '';

    dim_inactive = {
      enabled = helpers.defaultNullOpts.mkBool false ''
        If true, dims the background color of inactive window or buffer or split.
      '';

      shade = helpers.defaultNullOpts.mkStr "dark" ''
        Sets the shade to apply to the inactive split or window or buffer.
      '';

      percentage = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.15 ''
        percentage of the shade to apply to the inactive window, split or buffer.
      '';
    };

    no_italic = helpers.defaultNullOpts.mkBool false ''
      Force no italic.
    '';

    no_bold = helpers.defaultNullOpts.mkBool false ''
      Force no bold.
    '';

    no_underline = helpers.defaultNullOpts.mkBool false ''
      Force no underline.
    '';

    styles = {
      comments = helpers.defaultNullOpts.mkListOf types.str [ "italic" ] ''
        Define comments highlight properties.
      '';

      conditionals = helpers.defaultNullOpts.mkListOf types.str [ "italic" ] ''
        Define conditionals highlight properties.
      '';

      loops = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        Define loops highlight properties.
      '';

      functions = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        Define functions highlight properties.
      '';

      keywords = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        Define keywords highlight properties.
      '';

      strings = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        Define strings highlight properties.
      '';

      variables = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        Define variables highlight properties.
      '';

      numbers = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        Define numbers highlight properties.
      '';

      booleans = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        Define booleans highlight properties.
      '';

      properties = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        Define properties highlight properties.
      '';

      types = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        Define types highlight properties.
      '';

      operators = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        Define operators highlight properties.
      '';
    };

    color_overrides = genAttrs (flavours ++ [ "all" ]) (
      flavour:
      helpers.defaultNullOpts.mkAttrsOf types.str { } (
        if flavour == "all" then
          "Override colors for all the flavours."
        else
          "Override colors for the ${flavour} flavour."
      )
    );

    custom_highlights = helpers.mkNullOrStrLuaFnOr (with types; attrsOf anything) ''
      Override specific highlight groups to use other groups or a hex color.
      You can provide either a lua function or directly an attrs.

      Example:
      ```lua
        function(colors)
          return {
            Comment = { fg = colors.flamingo },
            ["@constant.builtin"] = { fg = colors.peach, style = {} },
            ["@comment"] = { fg = colors.surface2, style = { "italic" } },
          }
        end
      ```

      Default: `{}`
    '';

    default_integrations = helpers.defaultNullOpts.mkBool true ''
      Some integrations are enabled by default, you can control this behaviour with this option.
    '';

    integrations = helpers.mkNullOrOption (with types; attrsOf anything) ''
      Catppuccin provides theme support for other plugins in the Neovim ecosystem and extended
      Neovim functionality through _integrations_.

      To enable/disable an integration you just need to set it to `true`/`false`.

      Example:
      ```nix
        {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          treesitter = true;
          notify = false;
          mini = {
            enabled = true;
            indentscope_color = "";
          };
        }
      ```

      Default: see plugin source.
    '';
  };

  settingsExample = {
    flavour = "mocha";
    disable_underline = true;
    term_colors = true;
    color_overrides.mocha.base = "#1e1e2f";
    styles = {
      booleans = [
        "bold"
        "italic"
      ];
      conditionals = [ "bold" ];
    };
    integrations = {
      cmp = true;
      gitsigns = true;
      nvimtree = true;
      treesitter = true;
      notify = false;
      mini = {
        enabled = true;
        indentscope_color = "";
      };
    };
  };

  extraOptions = {
    byteCompile = mkOption {
      type = types.bool;
      description = ''
        Whether to byte compile the colorscheme during build step.
        When enabled, `setup()` function and any runtime re-configuration won't
        be available. Default flavour is `mocha`. `flavour = "auto"` is not
        supported, set it explicitly. Flavours can be switched in runtime with
        `:colorscheme catppuccin-frappe`, `:colorscheme catppuccin-latte` etc.
      '';
      default = false;
      example = true;
    };
  };

  extraConfig = cfg: {
    extraPlugins =
      let
        # Neovim which byte compiles catppuccin colorscheme to current directory
        neovim = pkgs.neovim.override {
          configure = {
            packages.catppuccin-nvim.start = [ cfg.package ];

            # Byte compile the colorscheme to current directory
            customRC = helpers.wrapLuaForVimscript ''
              require("catppuccin").setup(${
                helpers.toLuaObject (cfg.settings // { compile_path = helpers.mkRaw "vim.uv.cwd()"; })
              })
            '';
          };
        };

        pname = lib.getName cfg.package;
        version = lib.getVersion cfg.package;
        byteCompiledPackage = pkgs.vimUtils.toVimPlugin (
          pkgs.runCommandLocal pname { inherit pname version; } ''
            HOME=$(mktemp -d) ${lib.getExe neovim} --headless +q

            mkdir -p $out/colors

            # Copy all flavours to $out/colors
            ${lib.concatMapStrings (flavour: ''
              cp ${flavour} $out/colors/catppuccin-${flavour}.lua
            '') flavours}
            # Default flavour
            cp ${
              # Using upstream default for dark background
              if cfg.settings.flavour != null && cfg.settings.flavour != "auto" then
                cfg.settings.flavour
              else
                "mocha"
            } $out/colors/catppuccin.lua
          ''
        );
      in
      if cfg.byteCompile then [ byteCompiledPackage ] else [ cfg.package ];

    extraConfigLuaPre = mkIf (!cfg.byteCompile) ''
      require("catppuccin").setup(${helpers.toLuaObject cfg.settings})
    '';

    colorscheme = mkDefault "catppuccin";
  };
}
