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
        inlayHints = {
          inline = ''vim.fn.has("nvim-0.10") == 1'';
          onlyCurrentLine = false;
          onlyCurrentLineAutocmd = "CursorHold";
          showParameterHints = true;
          parameterHintsPrefix = "<- ";
          otherHintsPrefix = "=> ";
          maxLenAlign = false;
          maxLenAlignPadding = 1;
          rightAlign = false;
          rightAlignPadding = 7;
          highlight = "Comment";
          priority = 100;
        };
        ast = {
          roleIcons = {
            type = "🄣";
            declaration = "🄓";
            expression = "🄔";
            statement = ";";
            specifier = "🄢";
            templateArgument = "🆃";
          };
          kindIcons = {
            compound = "🄲";
            recovery = "🅁";
            translationUnit = "🅄";
            packExpansion = "🄿";
            templateTypeParm = "🅃";
            templateTemplateParm = "🅃";
            templateParamObject = "🅃";
          };
          highlights = {
            detail = "Comment";
          };
        };
        memoryUsage = {
          border = "none";
        };
        symbolInfo = {
          border = "none";
        };
      };
    };
  };
}
