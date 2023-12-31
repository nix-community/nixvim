{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.colorschemes.palette;
in {
  meta.maintainers = [maintainers.GaetanLepage];

  options.colorschemes.palette =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "palette.nvim";

      package = helpers.mkPackageOption "palette.nvim" pkgs.vimPlugins.palette-nvim;

      palettes = {
        main = helpers.defaultNullOpts.mkStr "dark" ''
          Palette for the main colors.
        '';

        accent = helpers.defaultNullOpts.mkStr "pastel" ''
          Palette for the accent colors.
        '';

        state = helpers.defaultNullOpts.mkStr "pastel" ''
          Palette for the state colors.
        '';
      };

      customPalettes =
        mapAttrs
        (
          name: colorNames:
            helpers.defaultNullOpts.mkAttrsOf (
              types.submodule {
                options =
                  genAttrs
                  colorNames
                  (
                    colorName:
                      mkOption {
                        type = types.str;
                        description = "Definition of color '${colorName}'";
                      }
                  );
              }
            )
            "{}"
            ''
              Custom palettes for ${name} colors.
            ''
        ) {
          main = [
            "color0"
            "color1"
            "color2"
            "color3"
            "color4"
            "color5"
            "color6"
            "color7"
            "color8"
          ];

          accent = [
            "accent0"
            "accent1"
            "accent2"
            "accent3"
            "accent4"
            "accent5"
            "accent6"
          ];

          state = [
            "error"
            "warning"
            "hint"
            "ok"
            "info"
          ];
        };

      italics = helpers.defaultNullOpts.mkBool true ''
        Whether to use italics.
      '';

      transparentBackground = helpers.defaultNullOpts.mkBool false ''
        Whether to use transparent background.
      '';

      caching = helpers.defaultNullOpts.mkBool true ''
        Whether to enable caching.
      '';

      cacheDir =
        helpers.defaultNullOpts.mkStr
        ''{__raw = "vim.fn.stdpath('cache') .. '/palette'";}''
        "Cache directory.";
    };

  config = mkIf cfg.enable {
    assertions =
      mapAttrsToList (
        name: defaultPaletteNames: let
          palette = cfg.palettes.${name};
          allowedPaletteNames = (attrNames cfg.customPalettes.${name}) ++ defaultPaletteNames;
        in {
          assertion = isString palette -> elem palette allowedPaletteNames;
          message = ''
            Nixvim: `colorschemes.palette.palettes.${name}` (${palette}") is not part of the allowed ${name} palette names (${concatStringsSep " " allowedPaletteNames}).
          '';
        }
      )
      {
        main = ["dark" "light"];
        accent = ["pastel" "dark" "bright"];
        state = ["pastel" "dark" "bright"];
      };

    colorscheme = "palette";

    extraPlugins = [
      cfg.package
      # Annoyingly, lspconfig is required, otherwise this line is breaking:
      # https://github.com/roobert/palette.nvim/blob/a808c190a4f74f73782302152ebf323660d8db5f/lua/palette/init.lua#L45https://github.com/roobert/palette.nvim/blob/a808c190a4f74f73782302152ebf323660d8db5f/lua/palette/init.lua#L45
      # An issue has been opened upstream to warn the maintainer: https://github.com/roobert/palette.nvim/issues/2
      pkgs.vimPlugins.nvim-lspconfig
    ];

    extraConfigLuaPre = let
      setupOptions = with cfg;
        {
          inherit palettes;
          custom_palettes = customPalettes;
          inherit italics;
          transparent_background = transparentBackground;
          inherit caching;
          cache_dir = cacheDir;
        }
        // cfg.extraOptions;
    in ''
      require('palette').setup(${helpers.toLuaObject setupOptions})
    '';
  };
}
