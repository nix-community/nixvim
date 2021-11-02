{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.lualine;
  helpers = import ../helpers.nix { lib = lib; };
  separators = mkOption {
    type = types.submodule {
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
    };
    default = { };
  };
  component_options = mode:
    mkOption {
      type = types.submodule {
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
      };
      default = { };
    };
in {
  options = {
    programs.nixvim.plugins.lualine = {
      enable = mkEnableOption "Enable airline";

      options = mkOption {
        type = types.submodule {
          options = {
            theme = mkOption {
              default = "auto";
              type = types.str;
              description = "The theme to use for lualine-nvim.";
            };
            section_separators = separators;
            component_separators = separators;
            disabled_filestypes = mkOption {
              type = types.listOf types.str;
              default = [ ];
              example = ''[ "lua" ]'';
              description = "filetypes to disable lualine on";
            };
            always_divide_middle = mkOption {
              type = types.bool;
              default = true;
              description =
                "When true left_sections (a,b,c) can't take over entire statusline";
            };
          };
        };
        default = { };
        description = "Options for lualine";
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
        default = { };
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
        type = types.listOf types.str;
        default = [ ];
        example = ''[ "fzf" ]'';
        description = "list of enabled extensions";
      };
    };
  };
  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.lualine-nvim ];
      extraConfigLua = ''require("lualine").setup{''
        + optionalString (cfg.options != { }) ''
          options = ${helpers.toLuaObject cfg.options};
        '' + optionalString (cfg.sections != { }) ''
          sections = ${helpers.toLuaObject cfg.sections};
        '' + optionalString (!isNull cfg.tabline) ''
          tabline = ${helpers.toLuaObject cfg.tabline};
        '' + optionalString (cfg.extensions != [ ]) ''
          extensions = ${helpers.toLuaObject cfg.extensions};
        '' + "}";
    };
  };
}
