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
        lualine_a = ["mode"];
        lualine_b = ["branch" "diff" "diagnostics"];
        lualine_c = ["filename"];
        lualine_x = ["encoding" "fileformat" "filetype"];
        lualine_y = ["progress"];
        lualine_z = ["location"];
      };
      inactiveSections = {
        lualine_c = ["filename"];
        lualine_x = ["location"];
      };
    };
  };

  example = {
    plugins.lualine = {
      enable = true;
      ignoreFocus = ["NvimTree"];
      sections = {
        lualine_c = [
          # you can specify only the sections you want to change
          {
            name = "filename";
            extraConfig.newfile_status = true;
            extraConfig.path = 1;
            extraConfig.shorting_target = 60;
          }
        ];
        lualine_z = [
          {name = "location";}
          {name = "%L";} # total lines
        ];
      };
      tabline = {
        lualine_a = [
          {
            name = "buffers";
            extraConfig.mode = 4;
            extraConfig.filetype_names = {
              TelescopePrompt = "Telescope";
              NvimTree = "NvimTree";
            };
          }
        ];
        lualine_z = [
          {
            name = "tabs";
            extraConfig.mode = 2;
          }
        ];
      };
      extensions = ["nvim-tree"];
    };
  };
}
