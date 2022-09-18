{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.lualine;
  helpers = import ../helpers.nix { lib = lib; };
  separators = mkOption {
    type = types.nullOr (types.submodule {
      options = {
        left = mkOption {
          default = " ";
          type = types.str;
          description = "left separator";
        };
        right = mkOption {
          default = " ";
          type = types.str;
          description = "right separator";
        };
      };
    });
    default = null;
  };
  component_options = mode:
    mkOption {
      type = types.nullOr (types.submodule {
        options = {
          mode = mkOption {
            type = types.str;
            default = "${mode}";
          };
          icons_enabled = mkOption {
            type = types.enum [ "True" "False" ];
            default = "True";
            description = "displays icons in alongside component";
          };
          icon = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "displays icon in front of the component";
          };
          separator = separators;
        };
      });
      default = null;
    };
in
{
  options = {
    plugins.lualine = {
      enable = mkEnableOption "Enable lualine";

      theme = mkOption {
        default = config.colorscheme;
        type = types.nullOr types.str;
        description = "The theme to use for lualine-nvim.";
      };

      sectionSeparators = separators;
      componentSeparators = separators;

      disabledFiletypes = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        example = ''[ "lua" ]'';
        description = "filetypes to disable lualine on";
      };

      alwaysDivideMiddle = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description =
          "When true, left_sections (a,b,c) can't take over entire statusline";
      };

      sections = mkOption {
        type = types.nullOr (types.submodule ({ ... }: {
          options = {
            lualine_a = component_options "mode";
            lualine_b = component_options "branch";
            lualine_c = component_options "filename";

            lualine_x = component_options "encoding";
            lualine_y = component_options "progress";
            lualine_z = component_options "location";
          };
        }));

        default = null;
      };

      tabline = mkOption {
        type = types.nullOr (types.submodule ({ ... }: {
          options = {
            lualine_a = component_options "";
            lualine_b = component_options "";
            lualine_c = component_options "";

            lualine_x = component_options "";
            lualine_y = component_options "";
            lualine_z = component_options "";
          };
        }));
        default = null;
      };
      extensions = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        example = ''[ "fzf" ]'';
        description = "list of enabled extensions";
      };
    };
  };
  config =
    let
      setupOptions = {
        options = {
          theme = cfg.theme;
          section_separators = cfg.sectionSeparators;
          component_separators = cfg.componentSeparators;
          disabled_filetypes = cfg.disabledFiletypes;
          always_divide_middle = cfg.alwaysDivideMiddle;
        };

        sections = cfg.sections;
        tabline = cfg.tabline;
        extensions = cfg.extensions;
      };
    in
    mkIf cfg.enable {
      extraPlugins = [ pkgs.vimPlugins.lualine-nvim ];
      extraConfigLua =
        ''require("lualine").setup(${helpers.toLuaObject setupOptions})'';
    };
}
