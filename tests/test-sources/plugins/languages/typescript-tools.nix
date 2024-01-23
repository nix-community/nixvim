{
  empty = {plugins.typescript-tools.enable = true;};

  # Upstream defaults (couldn't find defaults for on_attach or handlers)

  defaults = {
    plugins.typescript-tools = {
      enable = true;
      settings = {
        separateDiagnosticServer = true;
        publishDiagnosticOn = "insert_leave";
        exposeAsCodeAction = null;
        tsserverPath = null;
        tsserverPlugins = null;
        tsserverMaxMemory = "auto";
        tsserverFormatOptions = null;
        tsserverFilePreferences = null;
        tsserverLocale = "en";
        completeFunctionCalls = false;
        includeCompletionsWithInsertText = true;
        codeLens = "off";
        disableMemberCodeLens = true;
        jsxCloseTag = {
          enable = false;
          filetypes = ["javascriptreact" "typescriptreact"];
        };
      };
    };
  };
}
