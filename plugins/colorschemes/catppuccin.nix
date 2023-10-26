{
  pkgs,
  config,
  lib,
  ...
} @ args:
with lib; let
  cfg = config.colorschemes.catppuccin;
  helpers = import ../helpers.nix args;

  flavours = [
    "latte"
    "mocha"
    "frappe"
    "macchiato"
  ];
in {
  options = {
    colorschemes.catppuccin = {
      enable = mkEnableOption "catppuccin";

      package =
        helpers.mkPackageOption "catppuccin" pkgs.vimPlugins.catppuccin-nvim;

      flavour = helpers.defaultNullOpts.mkEnumFirstDefault flavours "Theme flavour";

      background = let
        mkBackgroundStyle = name:
          helpers.defaultNullOpts.mkEnumFirstDefault flavours "Background for ${name}";
      in {
        light = mkBackgroundStyle "light";
        dark = mkBackgroundStyle "dark";
      };

      terminalColors =
        helpers.defaultNullOpts.mkBool false
        "Configure the colors used when opening a :terminal in Neovim";

      transparentBackground =
        helpers.defaultNullOpts.mkBool false "Enable Transparent background";

      showBufferEnd =
        helpers.defaultNullOpts.mkBool false
        "show the '~' characters after the end of buffers";

      dimInactive = {
        enabled =
          helpers.defaultNullOpts.mkBool false
          "if true, dims the background color of inactive window or buffer or split";

        shade =
          helpers.defaultNullOpts.mkStr "dark"
          "sets the shade to apply to the inactive split or window or buffer";

        percentage =
          helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0)
          "0.15"
          "percentage of the shade to apply to the inactive window, split or buffer";
      };

      disableItalic = helpers.defaultNullOpts.mkBool false "Force no italic";

      disableBold = helpers.defaultNullOpts.mkBool false "Force no bold";

      styles = {
        comments =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str)
          ''[ "italic" ]'' "Define comments highlight properties";

        conditionals =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str)
          ''[ 'italic" ]'' "Define conditionals highlight properties";

        loops =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]"
          "Define loops highlight properties";

        functions =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]"
          "Define functions highlight properties";

        keywords =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]"
          "Define keywords highlight properties";

        strings =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]"
          "Define strings highlight properties";

        variables =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]"
          "Define variables highlight properties";

        numbers =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]"
          "Define numbers highlight properties";

        booleans =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]"
          "Define booleans highlight properties";

        properties =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]"
          "Define properties highlight properties";

        types =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]"
          "Define types highlight properties";

        operators =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]"
          "Define operators highlight properties";
      };

      colorOverrides =
        genAttrs
        (flavours ++ ["all"])
        (
          flavour:
            helpers.defaultNullOpts.mkNullable
            (with types; attrsOf str)
            "{}"
            (
              if flavour == "all"
              then "Override colors for all of the flavours."
              else "Override colors for the ${flavour} flavour."
            )
        );

      customHighlights =
        helpers.defaultNullOpts.mkNullable
        (with types; either str (attrsOf attrs)) "" ''
          Override specific highlight groups to use other groups or a hex color
          Example:
          function(colors)
              return {
                  Comment = { fg = colors.flamingo },
                  ["@constant.builtin"] = { fg = colors.peach, style = {} },
                  ["@comment"] = { fg = colors.surface2, style = { "italic" } },
              }
          end
        '';

      integrations = {
        aerial = helpers.defaultNullOpts.mkBool false "";

        alpha = helpers.defaultNullOpts.mkBool false "";

        barbar = helpers.defaultNullOpts.mkBool config.plugins.barbar.enable "";

        beacon = helpers.defaultNullOpts.mkBool false "";

        # TODO: bufferline = ;

        cmp = helpers.defaultNullOpts.mkBool config.plugins.nvim-cmp.enable "";

        coc_nvim = helpers.defaultNullOpts.mkBool false "";

        dap = {
          enabled = helpers.defaultNullOpts.mkBool false "";

          enable_ui = helpers.defaultNullOpts.mkBool false "";
        };

        dashboard =
          helpers.defaultNullOpts.mkBool config.plugins.dashboard.enable "";

        dropbar = {
          enabled = helpers.defaultNullOpts.mkBool true "";

          color_mode = helpers.defaultNullOpts.mkBool false "";
        };

        # TODO: requires additional setup
        feline = helpers.defaultNullOpts.mkBool false "";

        fern = helpers.defaultNullOpts.mkBool false "";

        fidget = helpers.defaultNullOpts.mkBool false "";

        flash = helpers.defaultNullOpts.mkBool false "";

        gitgutter =
          helpers.defaultNullOpts.mkBool config.plugins.gitgutter.enable "";

        gitsigns =
          helpers.defaultNullOpts.mkBool config.plugins.gitsigns.enable "";

        harpoon =
          helpers.defaultNullOpts.mkBool config.plugins.harpoon.enable "";

        headlines = helpers.defaultNullOpts.mkBool false "";

        hop = helpers.defaultNullOpts.mkBool false "";

        illuminate = helpers.defaultNullOpts.mkBool false "";

        indent_blankline = {
          enabled = helpers.defaultNullOpts.mkBool config.plugins.indent-blankline.enable "";

          scope_color = helpers.defaultNullOpts.mkStr "" "";

          colored_indent_levels = helpers.defaultNullOpts.mkBool false "";
        };

        leap = helpers.defaultNullOpts.mkBool false "";

        lightspeed = helpers.defaultNullOpts.mkBool false "";

        # TODO: lspsaga.setup call for custom kinds and colors
        lsp_saga =
          helpers.defaultNullOpts.mkBool config.plugins.lspsaga.enable "";

        lsp_trouble =
          helpers.defaultNullOpts.mkBool config.plugins.trouble.enable "";

        markdown = helpers.defaultNullOpts.mkBool false "";

        mason = helpers.defaultNullOpts.mkBool false "";

        mini = {
          enabled = helpers.defaultNullOpts.mkBool  config.plugins.mini.enable "";

          indentscope_color = helpers.defaultNullOpts.mkStr "" "";
        };

        native_lsp = {
          enabled = helpers.defaultNullOpts.mkBool config.plugins.lsp.enable "";

          virtual_text = {
            errors =
              helpers.defaultNullOpts.mkNullable (types.listOf types.str)
              ''[ "italic" ]'' "";

            hints =
              helpers.defaultNullOpts.mkNullable (types.listOf types.str)
              ''[ "italic" ]'' "";

            warnings =
              helpers.defaultNullOpts.mkNullable (types.listOf types.str)
              ''[ "italic" ]'' "";

            information =
              helpers.defaultNullOpts.mkNullable (types.listOf types.str)
              ''[ "italic" ]'' "";
          };

          underlines = {
            errors =
              helpers.defaultNullOpts.mkNullable (types.listOf types.str)
              ''[ "underline" ]'' "";

            hints =
              helpers.defaultNullOpts.mkNullable (types.listOf types.str)
              ''[ "underline" ]'' "";

            warnings =
              helpers.defaultNullOpts.mkNullable (types.listOf types.str)
              ''[ "underline" ]'' "";

            information =
              helpers.defaultNullOpts.mkNullable (types.listOf types.str)
              ''[ "underline" ]'' "";
          };
        };

        # TODO: require("nvim-navic").setup { highlight = true }
        #  or:  plugins.navic.highlight = true
        navic = {
          enabled = helpers.defaultNullOpts.mkBool false "";

          custom_bg = helpers.defaultNullOpts.mkStr "NONE" "";
        };

        neogit = helpers.defaultNullOpts.mkBool config.plugins.neogit.enable "";

        neotest = helpers.defaultNullOpts.mkBool false "";

        neotree =
          helpers.defaultNullOpts.mkBool config.plugins.neo-tree.enable "";

        noice = helpers.defaultNullOpts.mkBool config.plugins.noice.enable "";

        # TODO: NormalNvim = ;

        notifier = helpers.defaultNullOpts.mkBool false "";

        notify = helpers.defaultNullOpts.mkBool config.plugins.notify.enable "";

        nvimtree =
          helpers.defaultNullOpts.mkBool config.plugins.nvim-tree.enable "";

        octo = helpers.defaultNullOpts.mkBool false "";

        overseer = helpers.defaultNullOpts.mkBool false "";

        pounce = helpers.defaultNullOpts.mkBool false "";

        rainbow_delimiters = helpers.defaultNullOpts.mkBool true "";

        sandwich = helpers.defaultNullOpts.mkBool false "";

        semantic_tokens = helpers.defaultNullOpts.mkBool false "";

        symbols_outline = helpers.defaultNullOpts.mkBool false "";

        telekasten = helpers.defaultNullOpts.mkBool false "";

        telescope =
          helpers.defaultNullOpts.mkBool config.plugins.telescope.enable "";

        treesitter =
          helpers.defaultNullOpts.mkBool config.plugins.treesitter.enable "";

        treesitter_context =
          helpers.defaultNullOpts.mkBool config.plugins.treesitter.enable "";

        ts_rainbow =
          helpers.defaultNullOpts.mkBool
          true "";

        ts_rainbow2 = helpers.defaultNullOpts.mkBool true "";

        vim_sneak = helpers.defaultNullOpts.mkBool false "";

        vimwiki = helpers.defaultNullOpts.mkBool false "";

        which_key =
          helpers.defaultNullOpts.mkBool config.plugins.which-key.enable "";

        barbecue = {
          dim_dirname = helpers.defaultNullOpts.mkBool true "";

          bold_basename = helpers.defaultNullOpts.mkBool true "";

          dim_context = helpers.defaultNullOpts.mkBool false "";

          alt_background = helpers.defaultNullOpts.mkBool false "";
        };
      };
    };
  };
  config = mkIf cfg.enable {
    colorscheme = "catppuccin";
    extraPlugins = [cfg.package];
    options = {termguicolors = true;};
    extraConfigLuaPre = let
      setupOptions = with cfg; {
        inherit (cfg) flavour background styles integrations;
        transparent_background = transparentBackground;
        show_end_of_buffer = showBufferEnd;
        term_colors = terminalColors;
        dim_inactive = dimInactive;
        no_italic = disableItalic;
        no_bold = disableBold;
        color_overrides = colorOverrides;
        custom_highlights =
          helpers.ifNonNull' cfg.customHighlights
          (
            if isString customHighlights
            then helpers.mkRaw customHighlights
            else
              helpers.mkRaw ''
                function(colors)
                  return
                    ${helpers.toLuaObject customHighlights}
                end
              ''
          );
      };
    in ''
      require("catppuccin").setup(${helpers.toLuaObject setupOptions})
    '';
  };
}
