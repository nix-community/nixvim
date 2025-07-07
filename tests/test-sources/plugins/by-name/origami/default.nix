{
  empty = {
    plugins.origami.enable = true;
  };

  defaults = {
    plugins.origami = {
      enable = true;

      settings = {
        useLspFoldsWithTreesitterFallback = true;
        pauseFoldsOnSearch = true;
        foldtext = {
          enabled = true;
          padding = 3;
          lineCount = {
            template = "%d lines";
            hlgroup = "Comment";
          };
          diagnosticsCount = true;
          gitsignsCount = true;
        };
        autoFold = {
          enabled = true;
          kinds = [
            "comment"
            "imports"
          ];
        };
        foldKeymaps = {
          setup = true;
          hOnlyOpensOnFirstColumn = false;
        };
      };
    };
  };

  example = {
    plugins.origami = {
      enable = true;

      settings = {
        pauseFoldsOnSearch = true;
        setupFoldKeymaps = false;
      };
    };
  };
}
