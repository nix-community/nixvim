{
  empty = {
    plugins.sniprun.enable = true;
  };

  default = {
    plugins.sniprun = {
      enable = true;
      selectedInterpreters = [];
      replEnable = [];
      replDisable = [];
      interpreterOptions = {};
      display = [
        "Classic"
        "VirtualTextOk"
      ];
      liveDisplay = ["VirtualTextOk"];
      displayOptions = {
        terminalWidth = 45;
        notificationTimeout = 5;
      };
      showNoOutput = [
        "Classic"
        "TempFloatingWindow"
      ];
      snipruncolors = {
        SniprunVirtualTextOk = {
          bg = "#66eeff";
          fg = "#000000";
          ctermbg = "Cyan";
          ctermfg = "Black";
        };
        SniprunFloatingWinOk = {
          fg = "#66eeff";
          ctermfg = "Cyan";
        };
        SniprunVirtualTextErr = {
          bg = "#881515";
          fg = "#000000";
          ctermbg = "DarkRed";
          ctermfg = "Black";
        };
        SniprunFloatingWinErr = {
          fg = "#881515";
          ctermfg = "DarkRed";
        };
      };
      liveModeToggle = "off";
      borders = "single";
    };
  };
}
