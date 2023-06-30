{
  empty = {
    plugins.neogen.enable = true;
  };

  example = {
    plugins.neogen = {
      enable = true;

      enablePlaceholders = false;
      inputAfterComment = false;
      keymaps = {
        generate = "<leader>a";
        generateClass = "<leader>b";
        generateFile = "<leader>c";
        generateFunction = "<leader>d";
        generateType = "<leader>e";
      };
      keymapsSilent = true;
      languages = {
        csharp = {
          template = {
            annotation_convention = "...";
          };
        };
      };
      placeholderHighligt = "None";
      placeholdersText = {
        attribute = "attribute";
        class = "class";
        description = "description";
        kwargs = "kwargs";
        parameter = "parameter";
        throw = "throw";
        tparam = "tparam";
        type = "type";
        varargs = "varargs";
      };
      snippetEngine = "vsnip";
    };
  };
}
