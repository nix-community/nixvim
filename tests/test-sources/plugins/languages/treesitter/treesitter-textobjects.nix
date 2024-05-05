{
  empty = {
    plugins = {
      treesitter.enable = true;
      treesitter-textobjects.enable = true;
    };
  };

  example = {
    plugins = {
      treesitter.enable = true;
      treesitter-textobjects = {
        enable = true;

        select = {
          enable = true;
          disable = [ ];
          lookahead = true;
          keymaps = {
            af = "@function.outer";
            "if" = "@function.inner";
            ac = "@class.outer";
            ic = {
              query = "@class.inner";
              desc = "Select inner part of a class region";
            };
          };
          selectionModes = {
            "@parameter.outer" = "v";
            "@function.outer" = "V";
            "@class.outer" = "<c-v>";
          };
          includeSurroundingWhitespace = true;
        };
        swap = {
          enable = true;
          disable = [ ];
          swapNext = {
            "<leader>a" = "@parameter.inner";
          };
          swapPrevious = {
            "<leader>A" = "@parameter.inner";
          };
        };
        move = {
          enable = true;
          disable = [ ];
          setJumps = true;
          gotoNextStart = {
            "]m" = "@function.outer";
            "]]" = "@class.outer";
          };
          gotoNextEnd = {
            "]M" = "@function.outer";
            "][" = "@class.outer";
          };
          gotoPreviousStart = {
            "[m" = "@function.outer";
            "[[" = "@class.outer";
          };
          gotoPreviousEnd = {
            "[M" = "@function.outer";
            "[]" = "@class.outer";
          };
          gotoNext = {
            "]d" = "@conditional.outer";
          };
          gotoPrevious = {
            "[d" = "@conditional.outer";
          };
        };
        lspInterop = {
          enable = true;
          border = "none";
          peekDefinitionCode = {
            "<leader>df" = "@function.outer";
            "<leader>dF" = "@class.outer";
          };
          floatingPreviewOpts = { };
        };
      };
    };
  };
}
