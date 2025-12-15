{ pkgs }:
{
  default = {
    plugins.treesitter = {
      enable = true;
      folding = true;
      highlight.enable = true;
      indent.enable = true;

      settings = {
        install_dir.__raw = "vim.fs.joinpath(vim.fn.stdpath('data'), 'site')";
      };
    };
  };

  empty = {
    plugins.treesitter.enable = true;
  };

  empty-grammar-packages = {
    plugins.treesitter = {
      enable = true;
      grammarPackages = [ ];
    };
  };

  with-injections = {
    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      nixvimInjections = true;

      languageRegister = {
        cpp = "onelab";
        python = [
          "foo"
          "bar"
        ];
      };
    };
  };

  no-nix-grammars = {
    plugins.treesitter = {
      enable = true;
      nixGrammars = false;
    };
  };

  specific-grammars = {
    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        lua
        nix
        vim
        vimdoc
      ];
    };
  };

  legacy-master = {
    plugins.treesitter = {
      enable = true;

      settings = {
        auto_install = false;
        ensure_installed.__empty = { };
        ignore_install.__empty = { };
        parser_install_dir.__raw = "vim.fs.joinpath(vim.fn.stdpath('data'), 'treesitter')";
        sync_install = false;

        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
          disable = ''
            function(lang, bufnr)
              return api.nvim_buf_line_count(bufnr) > 50000
            end
          '';
        };

        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "gnn";
            node_incremental = "grn";
            scope_incremental = "grc";
            node_decremental = "grm";
          };
        };

        indent = {
          enable = true;
        };
      };
    };
  };
}
