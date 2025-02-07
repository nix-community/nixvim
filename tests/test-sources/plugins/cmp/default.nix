{
  empty = {
    plugins.cmp.enable = true;
  };

  snippet-engine = {
    plugins.cmp = {
      enable = true;
      settings.snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
    };
  };

  # Issue #536
  mappings = {
    plugins.cmp = {
      enable = true;
      settings.mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = false })";
        "<Tab>" = ''
          cmp.mapping(
            function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expandable() then
                luasnip.expand()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif check_backspace() then
                fallback()
              else
                fallback()
              end
            end,
            { "i", "s" }
          )
        '';
      };
    };
  };

  defaults = {
    plugins.cmp = {
      enable = true;

      settings = {
        performance = {
          debounce = 60;
          throttle = 30;
          fetchingTimeout = 500;
          asyncBudget = 1;
          maxViewEntries = 200;
        };
        preselect = "Item";
        snippet = {
          expand = ''
            function(_)
              error('snippet engine is not configured.')
            end
          '';
        };
        completion = {
          keywordLength = 1;
          keywordPattern = ''[[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]]'';
          autocomplete = [ "TextChanged" ];
          completeopt = "menu,menuone,noselect";
        };
        confirmation = {
          getCommitCharacters = ''
            function(commit_characters)
              return commit_characters
            end
          '';
        };
        formatting = {
          expandableIndicator = true;
          fields = [
            "abbr"
            "kind"
            "menu"
          ];
          format = ''
            function(_, vim_item)
              return vim_item
            end
          '';
        };
        matching = {
          disallowFuzzyMatching = false;
          disallowFullfuzzyMatching = false;
          disallowPartialFuzzyMatching = true;
          disallowPartialMatching = false;
          disallowPrefixUnmatching = false;
        };
        sorting = {
          priorityWeight = 2;
          comparators = [
            "offset"
            "exact"
            "score"
            "recently_used"
            "locality"
            "kind"
            "length"
            "order"
          ];
        };
        sources = [ ];
        experimental = {
          ghost_text = false;
        };
        view = {
          entries = {
            name = "custom";
            selection_order = "top_down";
          };
          docs = {
            autoOpen = true;
          };
        };
        window = {
          completion = {
            border = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None";
            scrolloff = 0;
            colOffset = 0;
            sidePadding = 1;
            scrollbar = true;
          };
          documentation = {
            maxHeight = "math.floor(40 * (40 / vim.o.lines))";
            maxWidth = "math.floor((40 * 2) * (vim.o.columns / (40 * 2 * 16 / 9)))";
            border.__raw = "cmp.config.window.bordered()";
            winhighlight = "FloatBorder:NormalFloat";
          };
        };
      };
    };
  };

  list-of-sources = {
    plugins.cmp = {
      enable = true;

      settings.sources = [
        { name = "path"; }
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        {
          name = "buffer";
          option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
        }
        { name = "neorg"; }
      ];
    };

    test.runNvim = false;
    test.warnings = expect: [
      # Expect a warning for each source in the list,
      # other than neorg for _some_ reason...
      (expect "count" 4)
    ];
  };

  list-of-lists-of-sources = {
    plugins.cmp = {
      enable = true;

      settings.sources.__raw = ''
        cmp.config.sources({
          {
            {name = "path"},
            {name = "nvim_lsp"}
          },
          {
            {
              name = "buffer",
              option = {
                get_bufnrs = vim.api.nvim_list_bufs
              }
            }
          },
        })
      '';
    };
  };

  example = {
    plugins.cmp = {
      enable = true;

      settings = {
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        window = {
          completion.__raw = "cmp.config.window.bordered";
          documentation.__raw = "cmp.config.window.bordered";
        };

        mapping = {
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
      };
    };
  };

  readme-example = {
    plugins.cmp = {
      enable = true;

      settings = {
        mapping.__raw = ''
          cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          })
        '';
        sources.__raw = ''
          cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
            -- { name = 'luasnip' },
            -- { name = 'ultisnips' },
            -- { name = 'snippy' },
          }, {
            { name = 'buffer' },
          })
        '';
      };

      filetype.gitcommit.sources.__raw = ''
        cmp.config.sources({
          { name = 'git' },
        }, {
          { name = 'buffer' },
        })
      '';

      cmdline = {
        "/" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          # Need to use a raw lua string as we only accept **flat** lists (not nested).
          sources.__raw = ''
            {
              { name = 'buffer' }
            }
          '';
        };
        "?" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          # Need to use a raw lua string as we only accept **flat** lists (not nested).
          sources.__raw = ''
            {
              { name = 'buffer' }
            }
          '';
        };
        ":" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources.__raw = ''
            cmp.config.sources({
              { name = 'path' }
            }, {
              { name = 'cmdline' }
            })
          '';
        };
      };
    };
  };
}
