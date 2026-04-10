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
          };
          move = {
            enable = true;
            disable.__empty = { };
            set_jumps = true;
          };
          lsp_interop = {
            enable = true;
            border = "none";
            floating_preview_opts.__empty = { };
          };
        };
      };
    };
  };
}
