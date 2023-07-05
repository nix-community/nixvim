{
  empty = {
    plugins.vim-illuminate.enable = true;
  };

  example = {
    plugins.vim-illuminate = {
      enable = true;
      delay = 50;
      providers = ["lsp"];
      modesDenylist = ["n"];
      modesAllowlist = ["v"];
      underCursor = false;
      largeFileCutoff = 10;
      minCountToHighlight = 2;
      filetypesDenylist = ["csharp"];
      filetypesAllowlist = ["python"];

      filetypeOverrides = [
        {
          filetype = "c";
          overrides = {
            delay = 10;
            providers = ["treesitter"];
          };
        }
      ];

      largeFileOverrides = {
        delay = 20;
        underCursor = true;
      };
    };
  };
}
