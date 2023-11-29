{
  default = {
    plugins.debugprint = {
      createKeymaps = true;
      displayCounter = true;
      displaySnippet = true;
      enable = false;
      filetypes = {};
      ignoreTreesitter = false;
      moveToDebugline = false;
      printTag = "DEBUGPRINT";
    };
  };

  empty.plugins.debugprint.enable = true;

  example = {
    plugins.debugprint = {
      createKeymaps = false;
      displayCounter = false;
      displaySnippet = false;
      enable = true;
      filetypes = {};
      ignoreTreesitter = true;
      moveToDebugline = true;
      printTag = "DEBUG";
    };
  };
}
