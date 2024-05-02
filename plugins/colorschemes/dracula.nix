{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "dracula";
    isColorscheme = true;
    originalName = "dracula.nvim";
    defaultPackage = pkgs.vimPlugins.dracula-nvim;

    maintainers = [maintainers.GaetanLepage];

    imports =
      map (
        oldOption:
          mkRemovedOptionModule
          ["colorschemes" "dracula" oldOption]
          ''
            Nixvim has switched from `dracula-vim` to `dracula.nvim` as a backend for the `dracula` colorscheme.
            Please, check the documentation to see the new options.
          ''
      )
      [
        "bold"
        "italic"
        "underline"
        "undercurl"
        "fullSpecialAttrsSupport"
        "highContrastDiff"
        "inverse"
        "colorterm"
      ];

    settingsOptions = {
      theme = mkOption {
        description = "The colorscheme to use.";
        default = "dracula";
        type = types.enum [
          "dracula"
          "dracula-soft"
        ];
        example = "dracula-soft";
      };

      colors = helpers.mkNullOrOption (with types; attrsOf str) ''
        Customize dracula color palette.

        Default: see source.
      '';

      show_end_of_buffer = helpers.defaultNullOpts.mkBool false ''
        Show the `~` characters after the end of buffers.
      '';

      transparent_bg = helpers.defaultNullOpts.mkBool false ''
        Use transparent background.
      '';

      lualine_bg_color = helpers.mkNullOrStr ''
        Set custom lualine background color.

        Example: "#44475a"
      '';

      italic_comment = helpers.defaultNullOpts.mkBool false ''
        Set italic comment.
      '';

      overrides =
        helpers.defaultNullOpts.mkNullable
        (
          with helpers.nixvimTypes;
            maybeRaw (attrsOf highlight)
        )
        "{}"
        ''
          Overrides the default highlights with an attrs see `:h synIDattr`.

          You can use overrides as table like this:
          ```nix
            overrides = {
              NonText.fg = "white"; # set NonText fg to white
              NvimTreeIndentMarker.link = "NonText"; # link to NonText highlight
              Nothing = {}; # clear highlight of Nothing
            };
          ```

          Or you can also use it like a function to get colors from theme:
          ```nix
            overrides.__raw = \'\'
              function (colors)
                return {
                  NonText = { fg = colors.white }, -- set NonText fg to white of theme
                }
              end
            \'\';
        '';
    };

    settingsExample = {
      theme = "dracula-soft";
      colors = {
        bg = "#282A36";
        fg = "#F8F8F2";
        selection = "#44475A";
      };
      show_end_of_buffer = true;
      transparent_bg = false;
      lualine_bg_color = "#44475a";
      italic_comment = true;
      overrides = {
        NonText.fg = "white";
        NvimTreeIndentMarker.link = "NonText";
        Nothing = {};
      };
    };

    colorscheme = null;
    extraConfig = cfg: {
      options.termguicolors = lib.mkDefault true;

      colorscheme = cfg.settings.theme;
    };
  }
