{
  empty = {
    plugins.neogen.enable = true;
  };

  example = {
    plugins.neogen = {
      enable = true;

      keymaps = {
        generate = "<leader>a";
        generateClass = "<leader>b";
        generateFile = "<leader>c";
        generateFunction = "<leader>d";
        generateType = "<leader>e";
      };
      keymapsSilent = true;

      settings = {
        enable_placeholders = false;
        input_after_comment = false;
        languages = {
          csharp = {
            template = {
              annotation_convention = "...";
            };
          };
        };
        placeholder_hl = "None";
        placeholders_text = {
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
        snippet_engine = "vsnip";
      };
    };
  };
}
