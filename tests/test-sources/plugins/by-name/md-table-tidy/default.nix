{
  empty = { config, ... }: {
    plugins = {
      treesitter = {
        enable = true;
        grammarPackages = [ config.plugins.treesitter.package.builtGrammars.markdown ];
      };
      md-table-tidy.enable = true;
    };
  };

  defaults = { config, ... }: {
    plugins = {
      treesitter = {
        enable = true;
        grammarPackages = [ config.plugins.treesitter.package.builtGrammars.markdown ];
      };
      md-table-tidy = {
        enable = true;
        settings = {
          padding = 1;
          keymap = {
            table_tidy = "<leader>tt";
            table_tidy_all = "<leader>ta";
          };
        };
      };
    };
  };

  example = { config, ... }: {
    plugins = {
      treesitter = {
        enable = true;
        grammarPackages = [ config.plugins.treesitter.package.builtGrammars.markdown ];
      };
      md-table-tidy = {
        enable = true;
        settings = {
          padding = 0;
          keymap = {
            table_tidy = "<leader>mt";
            table_tidy_all = "<leader>ma";
          };
        };
      };
    };
  };
}
