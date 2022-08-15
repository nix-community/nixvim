{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.lualine;
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

  sections_option = default: mkOption {
    type = types.nullOr (types.listOf types.str);
    default = default;
  };
in {
  options = {
    programs.nixvim.plugins.lualine = {
      enable = mkEnableOption "Enable lualine";

      theme = mkOption {
        default = config.programs.nixvim.colorscheme;
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
            lualine_a = sections_option "mode";
            lualine_b = sections_option "branch";
            lualine_c = sections_option "filename";

            lualine_x = sections_option "encoding";
            lualine_y = sections_option "progress";
            lualine_z = sections_option "location";
          };
        }));

        default = null;
      };

      tabline = mkOption {
        type = types.nullOr (types.submodule ({ ... }: {
          options = {
            lualine_a = sections_option "";
            lualine_b = sections_option "";
            lualine_c = sections_option "";

            lualine_x = sections_option "";
            lualine_y = sections_option "";
            lualine_z = sections_option "";
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
  config = let
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
  in mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.lualine-nvim ];
      extraConfigLua =
        ''require("lualine").setup(${helpers.toLuaObject setupOptions})'';
    };
  };
}
