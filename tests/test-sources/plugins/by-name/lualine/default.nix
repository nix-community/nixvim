{ pkgs, ... }:
{
  empty = {
    plugins.lualine.enable = true;
  };

  defaults = {
    plugins.lualine = {
      enable = true;

      settings = {
        options = {
          icons_enabled = true;
          theme = "auto";
          component_separators = {
            left = "";
            right = "";
          };
          section_separators = {
            left = "";
            right = "";
          };
          always_divide_middle = true;
          globalstatus = false;
          refresh = {
            statusline = 1000;
            tabline = 1000;
            winbar = 1000;
          };
        };
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [
            "branch"
            "diff"
            "diagnostics"
          ];
          lualine_c = [ "filename" ];
          lualine_x = [
            "encoding"
            "fileformat"
            "filetype"
          ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
        inactive_sections = {
          lualine_c = [ "filename" ];
          lualine_x = [ "location" ];
        };
      };
    };
  };

  example = {
    extraPlugins = [ pkgs.vimPlugins.gruvbox-nvim ];
    plugins.lualine = {
      enable = true;
      settings = {
        options = {
          component_separators = "|";
          theme.__raw = ''
            (function()
              local custom_gruvbox = require("lualine.themes.gruvbox")
              custom_gruvbox.normal.c.bg = '#112233'
              return custom_gruvbox
            end)()
          '';
          ignore_focus = [
            "NvimTree"
            "neo-tree"
          ];
          disabled_filetypes = {
            __unkeyed-1 = "startify";
            winbar = [ "neo-tree" ];
          };
        };
        sections = {
          lualine_a = [
            {
              __unkeyed-1 = "mode";
              separator.left = "";
              padding.left = 2;
            }
          ];
          lualine_c = [
            # you can specify only the sections you want to change
            {
              __unkeyed-1 = "filename";
              icon = "-";
              newfile_status = true;
              path = 1;
              shorting_target = 60;
            }
          ];
          lualine_z = [
            { __unkeyed-1 = "location"; }
            { __unkeyed-1 = "%L"; } # total lines
          ];
        };
        tabline = {
          lualine_a = [
            {
              __unkeyed-1 = "buffers";
              icon = {
                __unkeyed-1 = "X";
                align = "right";
              };
              mode = 4;
              filetype_names = {
                TelescopePrompt = "Telescope";
                NvimTree = "NvimTree";
              };
              fmt = ''
                function(value)
                  return value
                end
              '';
            }
          ];
          lualine_z = [
            {
              __unkeyed-1 = "tabs";
              mode = 2;
            }
          ];
        };
        extensions = [
          "nvim-tree"
          {
            sections = {
              lualine_a = [ "filename" ];
            };
            inactive_sections = {
              lualine_x = [ "location" ];
            };
            filetypes = [ "markdown" ];
          }
        ];
      };
    };
  };

  disabled-list = {
    plugins.lualine = {
      enable = true;
      settings.options.disabled_filetypes = [
        "neo-tree"
        "startify"
      ];
    };
  };

  no-packages = {
    plugins.lualine.enable = true;

    dependencies.git.enable = false;
  };
}
