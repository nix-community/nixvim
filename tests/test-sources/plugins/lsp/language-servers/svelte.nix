{
  example = {
    plugins.lsp = {
      enable = true;

      servers.svelte = {
        enable = true;

        initOptions = {
          svelte = {
            plugin = {
              typescript = {
                enable = true;
                diagnostics = {
                  enable = true;
                };
                hover = {
                  enable = true;
                };
                documentSymbols = {
                  enable = true;
                };
                completions = {
                  enable = true;
                };
                codeActions = {
                  enable = true;
                };
                selectionRange = {
                  enable = true;
                };
                signatureHelp = {
                  enable = true;
                };
                semanticTokens = {
                  enable = true;
                };
              };
              css = {
                enable = true;
                globals = null;
                diagnostics = {
                  enable = true;
                };
                hover = {
                  enable = true;
                };
                completions = {
                  enable = true;
                  emmet = true;
                };
                documentColors = {
                  enable = true;
                };
                colorPresentations = {
                  enable = true;
                };
                documentSymbols = {
                  enable = true;
                };
                selectionRange = {
                  enable = true;
                };
              };
              html = {
                enable = true;
                hover = {
                  enable = true;
                };
                completions = {
                  enable = true;
                  emmet = true;
                };
                tagComplete = {
                  enable = true;
                };
                documentSymbols = {
                  enable = true;
                };
                linkedEditing = {
                  enable = true;
                };
              };
              svelte = {
                enable = true;
                diagnostics = {
                  enable = true;
                };
                compilerWarnings = {
                  css-unused-selector = "ignore";
                  unused-export-let = "error";
                };
                format = {
                  enable = true;
                  config = {
                    svelteSortOrder = "options-scripts-markup-styles";
                    svelteStrictMode = false;
                    svelteAllowShorthand = true;
                    svelteBracketNewLine = true;
                    svelteIndentScriptAndStyle = true;
                    printWidth = 80;
                    singleQuote = false;
                  };
                };
                hover = {
                  enable = true;
                };
                completions = {
                  enable = true;
                };
                rename = {
                  enable = true;
                };
                codeActions = {
                  enable = true;
                };
                selectionRange = {
                  enable = true;
                };
                defaultScriptLanguage = null;
              };
            };
          };
        };
      };
    };
  };
}
