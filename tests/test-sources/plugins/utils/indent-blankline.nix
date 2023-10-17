{
  empty = {
    plugins.indent-blankline.enable = true;
  };

  defaults = {
    plugins.indent-blankline = {
      enable = true;

      debounce = 200;
      viewportBuffer = {
        min = 30;
        max = 500;
      };
      indent = {
        char = "▎";
        tabChar = null;
        highlight = null;
        smartIndentCap = true;
        priority = 1;
      };
      whitespace = {
        highlight = null;
        removeBlanklineTrail = true;
      };
      scope = {
        enabled = true;
        char = null;
        showStart = true;
        showEnd = true;
        showExactScope = false;
        injectedLanguages = true;
        highlight = null;
        priority = 1024;
        include = {
          nodeType = {};
        };
        exclude = {
          language = [];
          nodeType = {
            "*" = ["source_file" "program"];
            lua = ["chunk"];
            python = ["module"];
          };
        };
      };
      exclude = {
        filetypes = [
          "lspinfo"
          "packer"
          "checkhealth"
          "help"
          "man"
          "gitcommit"
          "TelescopePrompt"
          "TelescopeResults"
          "\'\'"
        ];
        buftypes = [
          "terminal"
          "nofile"
          "quickfix"
          "prompt"
        ];
      };
    };
  };
}
