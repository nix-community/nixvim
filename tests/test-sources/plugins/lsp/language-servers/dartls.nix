{
  example = {
    plugins.lsp = {
      enable = true;

      servers.dartls = {
        enable = true;

        settings = {
          analysisExcludedFolders = [
            "foo/bar"
            "./hello"
            "../bye/see/you/next/time"
          ];
          enableSdkFormatter = false;
          lineLength = 100;
          completeFunctionCalls = true;
          showTodos = true;
          renameFilesWithClasses = "prompt";
          enableSnippets = true;
          updateImportsOnRename = true;
          documentation = "full";
          includeDependenciesInWorkspaceSymbols = true;
        };
      };
    };
  };
}
