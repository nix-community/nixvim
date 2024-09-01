{ pkgs, ... }:
{
  empty = {
    plugins.lualine.enable = true;
  };

  defaults = {
    plugins.lualine = {
      enable = true;

      iconsEnabled = true;
      theme = "auto";
      componentSeparators = {
        left = "";
        right = "";
      };
      sectionSeparators = {
        left = "";
        right = "";
      };
      alwaysDivideMiddle = true;
      globalstatus = false;
      refresh = {
        statusline = 1000;
        tabline = 1000;
        winbar = 1000;
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
      inactiveSections = {
        lualine_c = [ "filename" ];
        lualine_x = [ "location" ];
      };
    };
  };

  example = {
    extraPlugins = [ pkgs.vimPlugins.gruvbox-nvim ];
    plugins.lualine = {
      enable = true;
      theme.__raw = ''
        (function()
          local custom_gruvbox = require("lualine.themes.gruvbox")
          custom_gruvbox.normal.c.bg = '#112233'
          return custom_gruvbox
        end)()
      '';
      ignoreFocus = [
        "NvimTree"
        "neo-tree"
      ];
      disabledFiletypes = {
        winbar = [ "neo-tree" ];
      };
      sections = {
        lualine_c = [
          # you can specify only the sections you want to change
          {
            name = "filename";
            icon = "-";
            extraConfig = {
              newfile_status = true;
              path = 1;
              shorting_target = 60;
            };
          }
        ];
        lualine_z = [
          { name = "location"; }
          { name = "%L"; } # total lines
        ];
      };
      tabline = {
        lualine_a = [
          {
            name = "buffers";
            icon = {
              icon = "X";
              align = "right";
            };
            extraConfig.mode = 4;
            extraConfig.filetype_names = {
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
            name = "tabs";
            extraConfig.mode = 2;
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

  no-packages = {
    plugins.lualine = {
      enable = true;
      gitPackage = null;
    };
  };
}
