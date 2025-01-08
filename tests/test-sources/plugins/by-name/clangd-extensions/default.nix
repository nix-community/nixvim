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
          inlay_hints = {
            inline = true;
            only_current_line = false;
            only_current_line_autocmd = [ "CursorHold" ];
            show_parameter_hints = true;
            parameter_hints_prefix = "<- ";
            other_hints_prefix = "=> ";
            max_len_align = false;
            max_len_align_padding = 1;
            right_align = false;
            right_align_padding = 7;
            highlight = "Comment";
            priority = 100;
          };
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
          inlay_hints = {
            inline = false;
            only_current_line_autocmd = [
              "CursorMoved"
              "CursorMovedI"
            ];
          };
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
