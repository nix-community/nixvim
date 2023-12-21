{
  empty = {
    plugins.debugprint.enable = true;
  };

  example = {
    plugins.debugprint = {
      enable = true;

      createKeymaps = true;
      createCommands = true;
      moveToDebugline = false;
      displayCounter = true;
      displaySnippet = true;
      filetypes = {
        python = {
          left = "print(f'";
          right = "')";
          midVar = "{";
          rightVar = "}')";
        };
      };
      ignoreTreesitter = false;
      printTag = "DEBUGPRINT";
    };
  };
}
