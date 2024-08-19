{
  empty = {
    plugins.openscad.enable = true;
  };

  defaults = {
    plugins.openscad = {
      enable = true;

      fuzzyFinder = "skim";
      cheatsheetWindowBlend = 15;
      loadSnippets = false;
      autoOpen = false;

      keymaps.enable = false;
    };
  };

  keymaps = {
    plugins.openscad = {
      enable = true;

      keymaps = {
        enable = true;
        cheatsheetToggle = "<Enter>";
        helpTrigger = "<A-h>";
        helpManualTrigger = "<A-m>";
        execOpenSCADTrigger = "<A-o>";
        topToggle = "<A-c>";
      };
    };
  };
}
