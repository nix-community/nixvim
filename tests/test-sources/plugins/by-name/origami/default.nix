{
  empty = {
    plugins.origami.enable = true;
  };

  defaults = {
    plugins.origami = {
      enable = true;

      settings = {
        keepFoldsAcrossSessions.__raw = "package.loaded['ufo'] ~= nil";
        pauseFoldsOnSearch = true;
        foldtextWithLineCount = {
          enabled.__raw = "package.loaded['ufo'] == nil";
          template = "   %s lines";
          hlgroupForCount = "Comment";
        };
        foldKeymaps = {
          setup = true;
          hOnlyOpensOnFirstColumn = false;
        };
        autoFold = {
          enabled = false;
          kinds = [
            "comment"
            "imports"
          ];
        };
      };
    };
  };

  example = {
    plugins = {
      nvim-ufo.enable = true;

      origami = {
        enable = true;

        settings = {
          keepFoldsAcrossSessions = true;
          pauseFoldsOnSearch = true;
          setupFoldKeymaps = false;
        };
      };
    };
  };
}
