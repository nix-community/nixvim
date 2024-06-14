{
  example = {
    plugins.lsp = {
      enable = true;

      servers.jsonnet-ls = {
        enable = true;

        settings = {
          Indent = 4;
          MaxBlankLines = 10;
          StringStyle = "single";
          CommentStyle = "leave";
          PrettyFieldNames = true;
          PadArrays = false;
          PadObjects = true;
          SortImports = false;
          UseImplicitPlus = true;
          StripEverything = false;
          StripComments = false;
        };
      };
    };
  };
}
