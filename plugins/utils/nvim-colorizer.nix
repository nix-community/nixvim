{ pkgs, config, lib, ... }:
with lib;
let

  cfg = config.plugins.nvim-colorizer;
  helpers = import ../helpers.nix { inherit lib; };

  colorizer-options = {
    RGB = mkOption {
      description = "#RGB hex codes";
      type = types.nullOr types.bool;
      default = null;
    };
    RRGGBB = mkOption {
      description = "#RRGGBB hex codes";
      type = types.nullOr types.bool;
      default = null;
    };
    names = mkOption {
      description = "\"Name\" codes like Blue or blue";
      type = types.nullOr types.bool;
      default = null;
    };
    RRGGBBAA = mkOption {
      description = "#RRGGBBAA hex codes";
      type = types.nullOr types.bool;
      default = null;
    };
    AARRGGBB = mkOption {
      description = "0xAARRGGBB hex codes";
      type = types.nullOr types.bool;
      default = null;
    };
    rgb_fn = mkOption {
      description = "CSS rgb() and rgba() functions";
      type = types.nullOr types.bool;
      default = null;
    };
    hsl_fn = mkOption {
      description = "CSS hsl() and hsla() functions";
      type = types.nullOr types.bool;
      default = null;
    };
    css = mkOption {
      description = "Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB";
      type = types.nullOr types.bool;
      default = null;
    };
    css_fn = mkOption {
      description = "Enable all CSS *functions*: rgb_fn, hsl_fn";
      type = types.nullOr types.bool;
      default = null;
    };
    mode = mkOption {
      description = "Set the display mode";
      type = types.nullOr (types.enum [ "foreground" "background" "virtualtext" ]);
      default = null;
    };
    tailwind = mkOption {
      description = "Enable tailwind colors";
      type = types.nullOr (
        types.oneOf [
          types.bool
          (types.enum [ "normal" "lsp" "both" ])
        ]
      );
      default = null;
    };
    sass = {
      enable = mkOption {
        description = "Enable sass colors";
        type = types.nullOr types.bool;
        default = null;
      };
      parsers = mkOption {
        description = "sass parsers settings";
        type = types.nullOr types.attrs;
        default = null;
      };
    };
    virtualtext = mkOption {
      description = "Set the virtualtext character (only used when mode is set to 'virtualtext')";
      type = types.nullOr types.str;
      default = null;
    };
  };

in
{
  options = {
    plugins.nvim-colorizer = {

      enable = mkEnableOption "nvim-colorizer";

      package = helpers.mkPackageOption "nvim-colorizer" pkgs.vimPlugins.nvim-colorizer-lua;

      fileTypes = mkOption {
        description = "Enable and/or configure highlighting for certain filetypes";
        type = types.nullOr (
          types.listOf (types.oneOf [
            types.str
            (types.submodule {
              options = {
                language = mkOption {
                  type = types.str;
                };
              } // colorizer-options;
            })
          ])
        );
        default = null;
      };

      userDefaultOptions = mkOption {
        description = "Default options";
        type = types.nullOr (types.submodule {
          options = colorizer-options;
        });
        default = null;
      };

      bufTypes = mkOption {
        description = "Buftype value is fetched by vim.bo.buftype";
        type = types.nullOr (types.listOf types.str);
        default = null;
      };
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    extraConfigLua = let

      filetypes = if (cfg.fileTypes != null)
        then (
          let
            list = map (
              v: if builtins.isAttrs v
                then v.language + " = " + helpers.toLuaObject (builtins.removeAttrs v [ "language" ])
                else "'${v}'"
            ) cfg.fileTypes;
          in "{" + (concatStringsSep "," list) + "}"
        )
        else
          "nil"
      ;

    in ''
      require("colorizer").setup({
        filetypes = ${filetypes},
        user_default_options = ${helpers.toLuaObject cfg.userDefaultOptions},
        buftypes = ${helpers.toLuaObject cfg.bufTypes},
      })
    '';
  };
}
