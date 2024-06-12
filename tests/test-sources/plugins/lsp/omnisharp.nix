{ pkgs, ... }:
{
  defaults = {
    plugins.lsp = {
      enable = true;

      servers.omnisharp = {
        # As of 2024-03-05, omnisharp-roslyn is broken on darwin
        # TODO: re-enable this test when fixed
        enable = !pkgs.stdenv.isDarwin;

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
