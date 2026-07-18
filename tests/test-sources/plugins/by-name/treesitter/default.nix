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
          assertion = lib.hasInfix "if disabled_language == lang or disabled_language == filetype then" config.content;
          message = "Treesitter highlight disable check should match language and filetype.";
        }
        {
          assertion = lib.hasInfix "if has_query('highlights') and not is_disabled(disabled_highlight) then" config.content;
          message = "Treesitter highlight should be enabled only if there are queries, and if not disabled.";
        }
        {
          assertion = lib.hasInfix "vim.treesitter.start(buf, lang)" config.content;
          message = "Treesitter highlighting should start with the resolved language.";
        }
        {
          assertion = lib.hasInfix ''add_undo_ftplugin(("call v:lua.vim.treesitter.stop(%d)"):format(buf))'' config.content;
          message = "Treesitter highlighting should stop after changing filetype.";
        }
        {
          assertion = lib.hasInfix ''local vim_syntax = { "jinja" }'' config.content;
          message = "Vim syntax enable list should be present in generated lua.";
        }
        {
          assertion = lib.hasInfix "if vim_syntax == true or is_disabled(vim_syntax) then" config.content;
          message = "Vim syntax should be enabled based on settings only.";
        }
        {
          assertion = lib.hasInfix "vim.bo[buf].syntax = 'ON'" config.content;
          message = "Vim syntax should be enabled for the resolved languages.";
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
          enableVimSyntax = [ "jinja" ];
        };
      };
    };

  disable-indent =
    { config, lib, ... }:
    {
      assertions = [
        {
          assertion = lib.hasInfix ''local disabled_indent = { "latex", "html" }'' config.content;
          message = "Treesitter indentation disable list should be present in generated lua.";
        }
        {
          assertion = lib.hasInfix "if has_query('indents') and not is_disabled(disabled_indent) then" config.content;
          message = "Treesitter indentation should be enabled only if there are queries, and if not disabled.";
        }
        {
          assertion = lib.hasInfix ''vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"'' config.content;
          message = "Treesitter indentation should start with the resolved language.";
        }
        {
          assertion = lib.hasInfix "add_undo_ftplugin('setlocal indentexpr<')" config.content;
          message = "Treesitter indentation should be disabled after changing filetype.";
        }
      ];

      plugins.treesitter = {
        enable = true;
        indent = {
          enable = true;
          disable = [
            "latex"
            "html"
          ];
        };
      };
    };

  disable-folding =
    { config, lib, ... }:
    {
      assertions = [
        {
          assertion = lib.hasInfix ''local disabled_folding = { "latex", "html" }'' config.content;
          message = "Treesitter folding disable list should be present in generated lua.";
        }
        {
          assertion = lib.hasInfix "if has_query('folds') and not is_disabled(disabled_folding) then" config.content;
          message = "Treesitter folding should be enabled only if there are queries, and if not disabled.";
        }
        {
          assertion = lib.hasInfix "vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'" config.content;
          message = "Treesitter folding should be enabled the resolved language.";
        }
        {
          assertion = lib.hasInfix "vim.wo[0][0].foldmethod = 'expr'" config.content;
          message = "Foldmethod should be expr.";
        }
        {
          assertion = lib.hasInfix "add_undo_ftplugin('setlocal foldexpr< foldmethod<')" config.content;
          message = "Treesitter folding should be disabled after changing filetype.";
        }
      ];

      plugins.treesitter = {
        enable = true;
        folding = {
          enable = true;
          disable = [
            "latex"
            "html"
          ];
        };
      };
    };

  disable-functions =
    { config, lib, ... }:
    {
      assertions = [
        {
          assertion = lib.hasInfix ''return lang == "highlight" and vim.api.nvim_buf_line_count(bufnr) > 50000'' config.content;
          message = "Treesitter highlight disable function should be present in generated lua.";
        }
        {
          assertion = lib.hasInfix ''return lang == "indent" and vim.api.nvim_buf_line_count(bufnr) > 50000'' config.content;
          message = "Treesitter indentation disable function should be present in generated lua.";
        }
        {
          assertion = lib.hasInfix ''return lang == "folding" and vim.api.nvim_buf_line_count(bufnr) > 50000'' config.content;
          message = "Treesitter folding disable function should be present in generated lua.";
        }
      ];

      plugins.treesitter = {
        enable = true;
        highlight = {
          enable = true;
          disable = lib.nixvim.mkRaw ''
            function(lang, bufnr, filetype)
              return lang == "highlight" and vim.api.nvim_buf_line_count(bufnr) > 50000
            end
          '';
        };
        indent = {
          enable = true;
          disable = lib.nixvim.mkRaw ''
            function(lang, bufnr, filetype)
              return lang == "indent" and vim.api.nvim_buf_line_count(bufnr) > 50000
            end
          '';
        };
        folding = {
          enable = true;
          disable = lib.nixvim.mkRaw ''
            function(lang, bufnr, filetype)
              return lang == "folding" and vim.api.nvim_buf_line_count(bufnr) > 50000
            end
          '';
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
    test.buildNixvim = false;
    test.warnings = expect: [
      (expect "count" 2)
      (expect "any" "`plugins.treesitter.settings.highlight.disable` is an upstream legacy nvim-treesitter")
      (expect "any" "use `plugins.treesitter.highlight.disable` instead.")
      (expect "any" "`plugins.treesitter.settings.indent.disable` is an upstream legacy nvim-treesitter")
      (expect "any" "use `plugins.treesitter.indent.disable` instead.")
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
      settings.indent = {
        enable = true;
        disable = [
          "latex"
          "html"
        ];
      };
    };
  };
}
