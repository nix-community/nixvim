{ pkgs }:
{
  default = {
    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      folding.enable = true;

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

  disable-highlighting =
    { config, lib, ... }:
    {
      assertions = [
        {
          assertion = lib.hasInfix ''local disabled_highlight = { "latex", "html" }'' config.content;
          message = "Treesitter highlight disable list should be present in generated lua.";
        }
        {
          assertion = lib.hasInfix "if disabled == lang or disabled == filetype then" config.content;
          message = "Treesitter highlight disable check should match language and filetype.";
        }
        {
          assertion = lib.hasInfix "pcall(vim.treesitter.start, args.buf, lang)" config.content;
          message = "Treesitter highlighting should start with the resolved language.";
        }
      ];

      plugins.treesitter = {
        enable = true;
        highlight = {
          enable = true;
          disable = [
            "latex"
            "html"
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
      package = pkgs.vimPlugins.nvim-treesitter-legacy;

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

  legacy-highlight-disable-warning = {
    test.runNvim = false;
    test.warnings = expect: [
      (expect "count" 1)
      (expect "any" "`plugins.treesitter.settings.highlight.disable` is an upstream legacy nvim-treesitter")
      (expect "any" "use `plugins.treesitter.highlight.disable` instead.")
    ];

    plugins.treesitter = {
      enable = true;
      settings.highlight = {
        enable = true;
        disable = [
          "latex"
          "html"
        ];
      };
    };
  };
}
