{ lib }:
{
  empty = {
    plugins.showkeys.enable = true;
  };

  defaults = {
    plugins.showkeys = {
      enable = true;

      settings = {
        winopts = {
          relative = "editor";
          style = "minimal";
          border = "single";
          height = 1;
          row = 1;
          col = 0;
          zindex = 100;
        };

        winhl = "FloatBorder:Comment,Normal:Normal";

        timeout = 3;
        maxkeys = 3;
        show_count = false;
        excluded_modes = lib.nixvim.emptyTable;

        position = "bottom-right";

        keyformat = {
          "<BS>" = "󰁮 ";
          "<CR>" = "󰘌";
          "<Space>" = "󱁐";
          "<Up>" = "󰁝";
          "<Down>" = "󰁅";
          "<Left>" = "󰁍";
          "<Right>" = "󰁔";
          "<PageUp>" = "Page 󰁝";
          "<PageDown>" = "Page 󰁅";
          "<M>" = "Alt";
          "<C>" = "Ctrl";
        };
      };
    };
  };

  example = {
    plugins.showkeys = {
      enable = true;
      settings = {
        maxkeys = 5;
        timeout = 5;
        position = "bottom-center";
        keyformat."<CR>" = "Enter";
      };
    };
  };
}
