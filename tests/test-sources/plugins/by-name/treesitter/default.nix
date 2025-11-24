{ pkgs }:
{
  default = {
    plugins.treesitter = {
      enable = true;

      settings = {
        auto_install = false;
        ensure_installed.__empty = { };
        ignore_install.__empty = { };
        # NOTE: This is our default, not the plugin's
        parser_install_dir.__raw = "vim.fs.joinpath(vim.fn.stdpath('data'), 'site')";

        sync_install = false;

        highlight = {
          additional_vim_regex_highlighting = false;
          enable = false;
          custom_captures.__empty = { };
          disable.__raw = "nil";
        };

        incremental_selection = {
          enable = false;
          keymaps = {
            init_selection = "gnn";
            node_incremental = "grn";
            scope_incremental = "grc";
            node_decremental = "grm";
          };
        };

        indent = {
          enable = false;
        };
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

  highlight-disable-function = {
    plugins.treesitter = {
      enable = true;

      settings = {
        highlight = {
          enable = true;
          disable = ''
            function(lang, bufnr)
              return api.nvim_buf_line_count(bufnr) > 50000
            end
          '';
        };
      };
    };
  };

  nixvim-injections = {
    plugins.treesitter = {
      enable = true;
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

  no-nix = {
    plugins.treesitter = {
      enable = true;
      nixGrammars = false;
    };
  };

  specific-grammars = {
    plugins.treesitter = {
      enable = true;

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        git_config
        git_rebase
        gitattributes
        gitcommit
        gitignore
        json
        jsonc
        lua
        make
        markdown
        meson
        ninja
        nix
        readline
        regex
        ssh-config
        toml
        vim
        vimdoc
        xml
        yaml
      ];
    };
  };

  disable-init-selection = {
    plugins.treesitter = {
      enable = true;

      settings = {
        incremental_selection = {
          enable = true;

          keymaps.init_selection = false;
        };
      };
    };
  };
}
