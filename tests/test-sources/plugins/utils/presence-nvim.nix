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

      # Rich presence text options.
      editing.text = "Editing %s";
      fileExplorer.text = "Browsing %s";
      gitCommit.text = "Committing changes";
      pluginManager.text = "Managing plugins";
      reading.text = "Reading %s";
      workspace.text = "Working on %s";
      lineNumber.text = "Line %s out of %s";
    };
  };
}
