{
  defaults = {
    plugins.lsp = {
      enable = true;

      servers.tinymist = {
        enable = true;

        settings = {
          outputPath = "$dir/$name";
          exportPdf = "auto";
          rootPath = null;
          semanticTokens = "enable";
          systemFonts = true;
          fontPaths = [ ];
          compileStatus = "disable";
          typstExtraArgs = [ ];
          formatterMode = "disable";
          formatterPrintWidth = 120;
          completion = {
            triggerOnSnippetPlaceholders = null;
            postfix = true;
            postfixUfcs = true;
            postfixUfcsLeft = true;
            postfixUfcsRight = true;
          };
        };
      };
    };
  };

  formatter-typstfmt = {
    plugins.lsp = {
      enable = true;

      servers.tinymist = {
        enable = true;
        settings.formatterMode = "typstfmt";
      };
    };
  };

  formatter-typstyle = {
    plugins.lsp = {
      enable = true;

      servers.tinymist = {
        enable = true;
        settings.formatterMode = "typstyle";
      };
    };
  };
}
