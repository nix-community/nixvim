{
  empty = {
    plugins.auto-session.enable = true;
  };

  example = {
    plugins.auto-session = {
      enable = true;

      logLevel = "error";
      autoSession = {
        enabled = true;
        enableLastSession = false;
        rootDir = {
          __raw = "vim.fn.stdpath 'data' .. '/sessions/'";
        };
        createEnabled = true;
        suppressDirs = null;
        allowedDirs = [ ];
        useGitBranch = true;
      };
      autoSave = {
        enabled = true;
      };
      autoRestore = {
        enabled = true;
      };
      cwdChangeHandling = {
        restoreUpcomingSession = true;
        preCwdChangedHook = null;
        postCwdChangedHook = null;
      };
      bypassSessionSaveFileTypes = [ ];
      sessionLens = {
        loadOnSetup = true;
        themeConf = {
          winblend = 10;
          border = true;
        };
        previewer = false;
        sessionControl = {
          controlDir = "vim.fn.stdpath 'data' .. '/auto_session/'";
          controlFilename = "session_control.json";
        };
      };
    };
  };
}
