{
  empty = {
    plugins = {
      lsp.enable = true;
      clangd-extensions.enable = true;
    };
  };

  default = {
    plugins = {
      lsp.enable = true;

      clangd-extensions = {
        enable = true;

        enableOffsetEncodingWorkaround = true;

        settings = {
          ast = {
            role_icons = {
              type = "🄣";
              declaration = "🄓";
              expression = "🄔";
              statement = ";";
              specifier = "🄢";
              "template argument" = "🆃";
            };
            kind_icons = {
              Compound = "🄲";
              Recovery = "🅁";
              TranslationUnit = "🅄";
              PackExpansion = "🄿";
              TemplateTypeParm = "🅃";
              TemplateTemplateParm = "🅃";
              TemplateParamObject = "🅃";
            };
            highlights = {
              detail = "Comment";
            };
          };
          memory_usage = {
            border = "none";
          };
          symbol_info = {
            border = "none";
          };
        };
      };
    };
  };

  example = {
    plugins = {
      lsp.enable = true;
      clangd-extensions = {
        enable = true;

        settings = {
          ast = {
            role_icons = {
              type = "";
              declaration = "";
              expression = "";
              specifier = "";
              statement = "";
              "template argument" = "";
            };
          };
        };
      };
    };
  };
}
