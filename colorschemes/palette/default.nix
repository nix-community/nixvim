{
  config,
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "palette";
  isColorscheme = true;
  package = "palette-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraPlugins = [
    # Annoyingly, lspconfig is required, otherwise this line is breaking:
    # https://github.com/roobert/palette.nvim/blob/a808c190a4f74f73782302152ebf323660d8db5f/lua/palette/init.lua#L45
    # An issue has been opened upstream to warn the maintainer: https://github.com/roobert/palette.nvim/issues/2
    config.plugins.lsp.package
  ];

  settingsOptions = {
    palettes = {
      main = defaultNullOpts.mkStr "dark" ''
        Palette for the main colors.
      '';

      accent = defaultNullOpts.mkStr "pastel" ''
        Palette for the accent colors.
      '';

      state = defaultNullOpts.mkStr "pastel" ''
        Palette for the state colors.
      '';
    };

    custom_palettes =
      lib.mapAttrs
        (
          name: colorNames:
          defaultNullOpts.mkAttrsOf
            (lib.types.submodule {
              options = lib.genAttrs colorNames (
                colorName:
                lib.mkOption {
                  type = lib.types.str;
                  description = "Definition of color '${colorName}'";
                }
              );
            })
            { }
            ''
              Custom palettes for ${name} colors.
            ''
        )
        {
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

    italics = defaultNullOpts.mkBool true ''
      Whether to use italics.
    '';

    transparent_background = defaultNullOpts.mkBool false ''
      Whether to use transparent background.
    '';

    caching = defaultNullOpts.mkBool true ''
      Whether to enable caching.
    '';

    cache_dir = defaultNullOpts.mkStr (lib.nixvim.literalLua "vim.fn.stdpath('cache') .. '/palette'") "Cache directory.";
  };

  settingsExample = { };

  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "colorschemes.palette" (
      lib.mapAttrsToList
        (
          name: defaultPaletteNames:
          let
            customPalettesNames = lib.attrNames cfg.settings.custom_palettes.${name};
            allowedPaletteNames = customPalettesNames ++ defaultPaletteNames;

            palette = cfg.settings.palettes.${name};
          in
          {
            assertion = lib.isString palette -> lib.elem palette allowedPaletteNames;
            message = ''
              `settings.palettes.${name}` (${palette}") is not part of the allowed ${name} palette names (${lib.concatStringsSep " " allowedPaletteNames}).
            '';
          }
        )
        {
          main = [
            "dark"
            "light"
          ];
          accent = [
            "pastel"
            "dark"
            "bright"
          ];
          state = [
            "pastel"
            "dark"
            "bright"
          ];
        }
    );
  };
}
