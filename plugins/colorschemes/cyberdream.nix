{
  config,
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "cyberdream";
    isColorscheme = true;
    originalName = "cyberdream.nvim";
    defaultPackage = pkgs.vimPlugins.cyberdream-nvim;

    maintainers = [helpers.maintainers.AndresBermeoMarinelli];

    settingsOptions = {
      transparent = helpers.defaultNullOpts.mkBool false ''
        Enable transparent background.
      '';

      italic_comments = helpers.defaultNullOpts.mkBool false ''
        Enable italics comments.
      '';

      hide_fillchars = helpers.defaultNullOpts.mkBool false ''
        Replace all fillchars with ' ' for the ultimate clean look.
      '';

      borderless_telescope = helpers.defaultNullOpts.mkBool true ''
        Modern borderless telescope theme.
      '';

      terminal_colors = helpers.defaultNullOpts.mkBool true ''
        Set terminal colors used in `:terminal`.
      '';

      theme = {
        highlights = helpers.defaultNullOpts.mkAttrsOf helpers.nixvimTypes.highlight "{}" ''
          Highlight groups to override, adding new groups is also possible.
          See `:h highlight-groups` for a list of highlight groups.

          Example:

          ```nix
          {
            Comment = {
              fg = "#696969";
              bg = "NONE";
              italic = true;
            };
          }
          ```

          Complete list can be found in `lua/cyberdream/theme.lua` in upstream repository.
        '';

        colors = helpers.defaultNullOpts.mkAttrsOf types.str "{}" ''
          Override the default colors used.

          For a full list of colors, see upstream documentation.
        '';
      };
    };

    settingsExample = {
      transparent = true;
      italic_comments = true;
      hide_fillchars = true;
      borderless_telescope = true;
      terminal_colors = true;

      theme = {
        highlights = {
          Comment = {
            fg = "#696969";
            bg = "NONE";
            italic = true;
          };
        };
        colors = {
          bg = "#000000";
          green = "#00ff00";
          magenta = "#ff00ff";
        };
      };
    };
  }
