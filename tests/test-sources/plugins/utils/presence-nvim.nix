{
  empty = {
    plugins.presence-nvim.enable = true;
  };

  defaults = {
    plugins.presence-nvim = {
      enable = true;

      # General options.
      autoUpdate = true;

      neovimImageText = "The One True Text Editor";
      mainImage = "neovim";

      clientId = "793271441293967371";
      logLevel = null;
      debounceTimeout = 10;
      enableLineNumber = false;

      blacklist = [];
      fileAssets = null;
      showTime = true;

      buttons = [];

      # Rich presence text options.
      editingText = "Editing %s";
      fileExplorerText = "Browsing %s";
      gitCommitText = "Committing changes";
      pluginManagerText = "Managing plugins";
      readingText = "Reading %s";
      workspaceText = "Working on %s";
      lineNumberText = "Line %s out of %s";
    };
  };
}
