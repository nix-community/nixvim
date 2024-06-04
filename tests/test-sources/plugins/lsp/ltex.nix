{
  example = {
    plugins.lsp = {
      enable = true;

      servers.ltex = {
        enable = true;

        settings = {
          enabled = [
            "bibtex"
            "context"
            "context.tex"
            "html"
            "latex"
            "markdown"
            "org"
            "restructuredtext"
            "rsweave"
          ];
          language = "en-US";
          dictionary = {
            "en-US" = [
              "adaptivity"
              "precomputed"
              "subproblem"
            ];
            "de-DE" = [
              "B-Splines"
              ":/path/to/externalFile.txt"
            ];
          };
          disabledRules = {
            "en-US" = [
              "EN_QUOTES"
              "UPPERCASE_SENTENCE_START"
              ":/path/to/externalFile.txt"
            ];
          };
          enabledRules = {
            "en-GB" = [
              "PASSIVE_VOICE"
              "OXFORD_SPELLING_NOUNS"
              ":/path/to/externalFile.txt"
            ];
          };
          hiddenFalsePositives = {
            "en-US" = [":/path/to/externalFile.txt"];
          };
          fields = {
            maintitle = false;
            seealso = true;
          };
          latex = {
            commands = {
              "\\label{}" = "ignore";
              "\\documentclass[]{}" = "ignore";
              "\\cite{}" = "dummy";
              "\\cite[]{}" = "dummy";
            };
            environments = {
              lstlisting = "ignore";
              verbatim = "ignore";
            };
          };
          markdown = {
            nodes = {
              CodeBlock = "ignore";
              FencedCodeBlock = "ignore";
              AutoLink = "dummy";
              Code = "dummy";
            };
          };
          configurationTarget = {
            dictionary = "workspaceFolderExternalFile";
            disabledRules = "workspaceFolderExternalFile";
            hiddenFalsePositives = "workspaceFolderExternalFile";
          };
          additionalRules = {
            enablePickyRules = false;
            motherTongue = "de-DE";
            languageModel = "";
            neuralNetworkModel = "";
            word2VecModel = "";
          };
          languageToolHttpServerUri = "";
          languageToolOrg = {
            username = "";
            apiKey = "";
          };
          ltex-ls = {
            path = "";
            logLevel = "fine";
          };
          java = {
            path = "";
            initialHeapSize = 64;
            maximumHeapSize = 512;
          };
          sentenceCacheSize = 2000;
          completionEnabled = true;
          diagnosticSeverity = {
            PASSIVE_VOICE = "hint";
            default = "information";
          };
          checkFrequency = "edit";
          clearDiagnosticsWhenClosingFile = true;
          statusBarItem = false;
          trace = {
            server = "off";
          };
        };
      };
    };
  };
}
