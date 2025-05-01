{
  empty = {
    lsp.servers.clangd.enable = true;

    plugins = {
      clangd-extensions.enable = true;
    };
  };

  default = {
    lsp.servers.clangd.enable = true;

    plugins = {
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
    lsp.servers.clangd.enable = true;

    plugins = {
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

  emptyOld = {
    plugins = {
      lsp.enable = true;
      clangd-extensions.enable = true;
    };
  };
}
