{
  defaults = {
    plugins.lsp = {
      enable = true;

      servers.tinymist = {
        enable = true;

        settings = {
          outputPath = "$dir/$name";
          exportPdf = "auto";
          rootPath.__raw = "nil";
          semanticTokens = "enable";
          systemFonts = true;
          fontPaths.__empty = { };
          compileStatus = "disable";
          typstExtraArgs.__empty = { };
          formatterMode = "disable";
          formatterPrintWidth = 120;
          completion = {
            triggerOnSnippetPlaceholders.__raw = "nil";
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
