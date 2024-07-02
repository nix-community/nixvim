{ pkgs, ... }:
{
  default = {
    plugins.treesitter = {
      enable = true;

      settings = {
        auto_install = false;
        ensure_installed = [ ];
        ignore_install = [ ];
        parser_install_dir = null;
        sync_install = false;

        highlight = {
          additional_vim_regex_highlighting = false;
          enable = false;
          custom_captures = { };
          disable = null;
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
    # TODO: See if we can build parsers (legacy way)
    tests.dontRun = true;
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
}
