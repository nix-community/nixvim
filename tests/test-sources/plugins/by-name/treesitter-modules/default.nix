{
  empty = {
    plugins.treesitter.enable = true;
    plugins.treesitter-modules.enable = true;
  };

  defaults = {
    plugins.treesitter.enable = true;
    plugins.treesitter-modules = {
      enable = true;

      settings = {
        ensure_installed = [ ];
        ignore_install = [ ];
        sync_install = false;
        install_options = { };
        auto_install = false;
        fold = {
          enable = false;
          disable = false;
        };
        highlight = {
          enable = false;
          disable = false;
          additional_vim_regex_highlighting = false;
        };
        incremental_selection = {
          enable = false;
          disable = false;
          keymaps = {
            init_selection = "gnn";
            node_incremental = "grn";
            scope_incremental = "grc";
            node_decremental = "grm";
          };
        };
        indent = {
          enable = false;
          disable = false;
        };
      };
    };
  };

  example = {
    plugins.treesitter.enable = true;
    plugins.treesitter-modules = {
      enable = true;

      settings = {
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<A-o>";
            node_incremental = "<A-o>";
            scope_incremental = "<A-O>";
            node_decremental = "<A-i>";
          };
        };
      };
    };
  };
}
