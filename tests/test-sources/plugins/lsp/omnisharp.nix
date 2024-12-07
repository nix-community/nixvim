{
  defaults = {
    plugins.lsp = {
      enable = true;

      servers.omnisharp = {
        # Package ‘dotnet-core-combined’ is marked as insecure, refusing to evaluate.
        # Dotnet SDK 6.0.428 is EOL, please use 8.0 (LTS) or 9.0 (Current)
        # https://github.com/NixOS/nixpkgs/pull/358533
        enable = false;

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
