{
  defaults = {
    plugins.lsp = {
      enable = true;

      servers.omnisharp = {
        enable = true;

        settings = {
          enableEditorConfigSupport = true;
          enableMsBuildLoadProjectsOnDemand = false;
          enableRoslynAnalyzers = false;
          organizeImportsOnFormat = false;
          enableImportCompletion = false;
          sdkIncludePrereleases = true;
          analyzeOpenDocumentsOnly = true;
        };
      };
    };
  };
}
