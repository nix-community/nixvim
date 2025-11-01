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

        settings = {
          select = {
            enable = true;
            disable.__empty = { };
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
            selection_modes = {
              "@parameter.outer" = "v";
              "@function.outer" = "V";
              "@class.outer" = "<c-v>";
            };
            include_surrounding_whitespace = true;
          };
          swap = {
            enable = true;
            disable.__empty = { };
            swap_next = {
              "<leader>a" = "@parameter.inner";
            };
            swap_previous = {
              "<leader>A" = "@parameter.inner";
            };
          };
          move = {
            enable = true;
            disable.__empty = { };
            set_jumps = true;
            goto_next_start = {
              "]m" = "@function.outer";
              "]]" = "@class.outer";
            };
            goto_next_end = {
              "]M" = "@function.outer";
              "][" = "@class.outer";
            };
            goto_previous_start = {
              "[m" = "@function.outer";
              "[[" = "@class.outer";
            };
            goto_previous_end = {
              "[M" = "@function.outer";
              "[]" = "@class.outer";
            };
            goto_next = {
              "]d" = "@conditional.outer";
            };
            goto_previous = {
              "[d" = "@conditional.outer";
            };
          };
          lsp_interop = {
            enable = true;
            border = "none";
            peek_definition_code = {
              "<leader>df" = "@function.outer";
              "<leader>dF" = "@class.outer";
            };
            floating_preview_opts.__empty = { };
          };
        };
      };
    };
  };
}
