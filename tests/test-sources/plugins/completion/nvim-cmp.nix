{
  # Empty configuration
  empty = {
    plugins.nvim-cmp.enable = true;
  };

  snippetEngine = {
    plugins.nvim-cmp = {
      enable = true;
      snippet.expand = "luasnip";
    };
  };

  # Issue #536
  mappings = {
    plugins.nvim-cmp = {
      enable = true;
      mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = false })";
        "<Tab>" = {
          modes = ["i" "s"];
          action = ''
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
            end
          '';
        };
      };
    };
  };

  # All the upstream default options of nvim-cmp
  defaults = {
    plugins.nvim-cmp = {
      enable = true;

      performance = {
        debounce = 60;
        throttle = 30;
        fetchingTimeout = 500;
        asyncBudget = 1;
        maxViewEntries = 200;
      };
      preselect = "Item";
      snippet = {
        expand.__raw = ''
          function(_)
            error('snippet engine is not configured.')
          end
        '';
      };
      completion = {
        keywordLength = 1;
        keywordPattern = ''\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)'';
        autocomplete = ["TextChanged"];
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
        fields = ["abbr" "kind" "menu"];
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
      sources = [];
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
          border = ["" "" "" "" "" "" "" ""];
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None";
          scrolloff = 0;
          colOffset = 0;
          sidePadding = 1;
          scrollbar = true;
        };
        documentation = {
          maxHeight = "math.floor(40 * (40 / vim.o.lines))";
          maxWidth = "math.floor((40 * 2) * (vim.o.columns / (40 * 2 * 16 / 9)))";
          border = ["" "" "" " " "" "" "" " "];
          winhighlight = "FloatBorder:NormalFloat";
        };
      };
    };
  };
}
