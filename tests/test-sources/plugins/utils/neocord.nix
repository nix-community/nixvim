{
  empty = {
    plugins.neocord.enable = true;
  };

  defaults = {
    plugins.neocord = {
      enable = true;

      # General options.
      autoUpdate = true;
      logo = "auto";
      logoTooltip = null;

      mainImage = "language";
      clientId = "1157438221865717891";
      logLevel = null;
      debounceTimeout = 10;

      enableLineNumber = false;
      blacklist = [];
      fileAssets = null;

      showTime = true;
      globalTimer = false;

      buttons = [];

      # Rich presence text options.
      editingText = "Editing %s";
      fileExplorerText = "Browsing %s";
      gitCommitText = "Committing changes";
      pluginManagerText = "Managing plugins";
      readingText = "Reading %s";
      workspaceText = "Working on %s";
      lineNumberText = "Line %s out of %s";
      terminalText = "Using Terminal";
    };
  };
}
