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
          compileStatus = "enable";
          typstExtraArgs = [ ];
          serverPath = null;
          "trace.server" = "off";
          formatterMode = "disable";
          formatterPrintWidth = 120;
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
