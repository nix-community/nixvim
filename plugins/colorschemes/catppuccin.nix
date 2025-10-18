{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption mkNullOrStrLuaFnOr;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "catppuccin";
  isColorscheme = true;
  package = "catppuccin-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions =
    let
      flavours = [
        "latte"
        "mocha"
        "frappe"
        "macchiato"
      ];
    in
    {
      compile_path = defaultNullOpts.mkStr {
        __raw = "vim.fn.stdpath 'cache' .. '/catppuccin'";
      } "Set the compile cache directory.";

      flavour = mkNullOrOption (types.enum (flavours ++ [ "auto" ])) ''
        Theme flavour.
      '';

      background =
        let
          mkBackgroundStyle =
            name:
            defaultNullOpts.mkEnumFirstDefault flavours ''
              Background for `${name}` background.
            '';
        in
        {
          light = mkBackgroundStyle "light";

          dark = mkBackgroundStyle "dark";
        };

      transparent_background = defaultNullOpts.mkBool false ''
        Enable Transparent background.
      '';

      show_end_of_buffer = defaultNullOpts.mkBool false ''
        Show the '~' characters after the end of buffers.
      '';

      term_colors = defaultNullOpts.mkBool false ''
        Configure the colors used when opening a :terminal in Neovim.
      '';

      dim_inactive = {
        enabled = defaultNullOpts.mkBool false ''
          If true, dims the background color of inactive window or buffer or split.
        '';

        shade = defaultNullOpts.mkStr "dark" ''
          Sets the shade to apply to the inactive split or window or buffer.
        '';

        percentage = defaultNullOpts.mkProportion 0.15 ''
          percentage of the shade to apply to the inactive window, split or buffer.
        '';
      };

      no_italic = defaultNullOpts.mkBool false ''
        Force no italic.
      '';

      no_bold = defaultNullOpts.mkBool false ''
        Force no bold.
      '';

      no_underline = defaultNullOpts.mkBool false ''
        Force no underline.
      '';

      styles = {
        comments = defaultNullOpts.mkListOf types.str [ "italic" ] ''
          Define comments highlight properties.
        '';

        conditionals = defaultNullOpts.mkListOf types.str [ "italic" ] ''
          Define conditionals highlight properties.
        '';

        loops = defaultNullOpts.mkListOf types.str [ ] ''
          Define loops highlight properties.
        '';

        functions = defaultNullOpts.mkListOf types.str [ ] ''
          Define functions highlight properties.
        '';

        keywords = defaultNullOpts.mkListOf types.str [ ] ''
          Define keywords highlight properties.
        '';

        strings = defaultNullOpts.mkListOf types.str [ ] ''
          Define strings highlight properties.
        '';

        variables = defaultNullOpts.mkListOf types.str [ ] ''
          Define variables highlight properties.
        '';

        numbers = defaultNullOpts.mkListOf types.str [ ] ''
          Define numbers highlight properties.
        '';

        booleans = defaultNullOpts.mkListOf types.str [ ] ''
          Define booleans highlight properties.
        '';

        properties = defaultNullOpts.mkListOf types.str [ ] ''
          Define properties highlight properties.
        '';

        types = defaultNullOpts.mkListOf types.str [ ] ''
          Define types highlight properties.
        '';

        operators = defaultNullOpts.mkListOf types.str [ ] ''
          Define operators highlight properties.
        '';
      };

      color_overrides = lib.genAttrs (flavours ++ [ "all" ]) (
        flavour:
        defaultNullOpts.mkAttrsOf types.str { } (
          if flavour == "all" then
            "Override colors for all the flavours."
          else
            "Override colors for the ${flavour} flavour."
        )
      );

      custom_highlights = mkNullOrStrLuaFnOr (with types; attrsOf anything) ''
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

      default_integrations = defaultNullOpts.mkBool true ''
        Some integrations are enabled by default, you can control this behaviour with this option.
      '';

      integrations = mkNullOrOption (with types; attrsOf anything) ''
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

  extraConfig = {
    opts.termguicolors = lib.mkDefault true;
  };
}
