{
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts literalLua;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "monokai-pro";
  isColorscheme = true;
  packPathName = "monokai-pro.nvim";
  package = "monokai-pro-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    transparent_background = defaultNullOpts.mkBool false ''
      Whether to enable transparent background.
    '';

    terminal_colors = defaultNullOpts.mkBool true ''
      Whether to use terminal colors.
    '';

    devicons = defaultNullOpts.mkBool false ''
      Whether to use devicons characters.
    '';

    styles =
      defaultNullOpts.mkAttrsOf (with types; attrsOf anything)
        {
          comment.italic = true;
          keyword.italic = true;
          type.italic = true;
          storageclass.italic = true;
          structure.italic = true;
          parameter.italic = true;
          annotation.italic = true;
          tag_attribute.italic = true;
        }
        ''
          Set the style for specific elements.
        '';

    filter = defaultNullOpts.mkStr' {
      pluginDefault = literalLua "vim.o.background == 'light' and 'classic' or 'pro'";
      example = "ristretto";
      description = ''
        Which filter to use.
      '';
    };

    day_night = {
      enable = defaultNullOpts.mkBool false ''
        Whether to enable day/night mode.
      '';

      day_filter = defaultNullOpts.mkStr' {
        pluginDefault = "pro";
        example = "classic";
        description = ''
          Which day filter to use.
        '';
      };

      night_filter = defaultNullOpts.mkStr' {
        pluginDefault = "spectrum";
        example = "octagon";
        description = ''
          Which night filter to use.
        '';
      };
    };

    inc_search = defaultNullOpts.mkEnum [ "underline" "background" ] "background" ''
      Incremental search look.
    '';

    background_clear =
      defaultNullOpts.mkListOf types.str
        [
          "toggleterm"
          "telescope"
          "renamer"
          "notify"
        ]
        ''
          List of plugins for which the background should be clear.
        '';

    plugins =
      defaultNullOpts.mkAttrsOf (with types; attrsOf anything)
        {
          bufferline = {
            underline_selected = false;
            underline_visible = false;
            underline_fill = false;
            bold = true;
          };
          indent_blankline = {
            context_highlight = "default";
            context_start_underline = false;
          };
        }
        ''
          Override configuration for specific plugins.
        '';
  };

  settingsExample = {
    terminal_colors = false;
    devicons = true;
    filter = "ristretto";
  };

  extraConfig = cfg: {
    warnings =
      lib.optional
        (
          (lib.isBool cfg.settings.devicons) && cfg.settings.devicons && (!config.plugins.web-devicons.enable)
        )
        ''
          Nixvim (colorschemes.monokai-pro): You have enabled `settings.devicons` but `plugins.web-devicons.enable` is `false`.
          Consider enabling the plugin for proper devicons support.
        '';
  };
}
