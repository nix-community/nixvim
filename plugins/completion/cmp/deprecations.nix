{lib, ...}:
with lib; let
  oldPluginBasePath = ["plugins" "nvim-cmp"];
  newPluginBasePath = ["plugins" "cmp"];
  settingsPath = newPluginBasePath ++ ["settings"];

  renamedOptions = [
    {old = ["performance" "debounce"];}
    {old = ["performance" "throttle"];}
    {
      old = ["performance" "fetchingTimeout"];
      new = ["performance" "fetching_timeout"];
    }
    {
      old = ["performance" "asyncBudget"];
      new = ["performance" "async_budget"];
    }
    {
      old = ["performance" "maxViewEntries"];
      new = ["performance" "max_view_entries"];
    }
    {old = ["mapping"];}
    {
      old = ["completion" "keywordLength"];
      new = ["completion" "keyword_length"];
    }
    {
      old = ["completion" "keywordPattern"];
      new = ["completion" "keyword_pattern"];
    }
    {old = ["completion" "autocomplete"];}
    {old = ["completion" "completeopt"];}
    {
      old = ["confirmation" "getCommitCharacters"];
      new = ["confirmation" "get_commit_characters"];
    }
    {
      old = ["formatting" "expandableIndicator"];
      new = ["formatting" "expandable_indicator"];
    }
    {old = ["formatting" "fields"];}
    {old = ["formatting" "format"];}
    {
      old = ["matching" "disallowFuzzyMatching"];
      new = ["matching" "disallow_fuzzy_matching"];
    }
    {
      old = ["matching" "disallowFullfuzzyMatching"];
      new = ["matching" "disallow_fullfuzzy_matching"];
    }
    {
      old = ["matching" "disallowPartialFuzzyMatching"];
      new = ["matching" "disallow_partial_fuzzy_matching"];
    }
    {
      old = ["matching" "disallowPartialMatching"];
      new = ["matching" "disallow_partial_matching"];
    }
    {
      old = ["matching" "disallowPrefixUnmatching"];
      new = ["matching" "disallow_prefix_unmatching"];
    }
    {
      old = ["sorting" "priorityWeight"];
      new = ["sorting" "priority_weight"];
    }
    {old = ["view" "entries"];}
    {
      old = ["view" "docs" "autoOpen"];
      new = ["view" "docs" "auto_open"];
    }
    {old = ["window" "completion" "border"];}
    {old = ["window" "completion" "winhighlight"];}
    {old = ["window" "completion" "zindex"];}
    {old = ["window" "completion" "scrolloff"];}
    {
      old = ["window" "completion" "colOffset"];
      new = ["window" "completion" "col_offset"];
    }
    {
      old = ["window" "completion" "sidePadding"];
      new = ["window" "completion" "side_padding"];
    }
    {old = ["window" "completion" "scrollbar"];}
    {old = ["window" "documentation" "border"];}
    {old = ["window" "documentation" "winhighlight"];}
    {old = ["window" "documentation" "zindex"];}
    {
      old = ["window" "documentation" "maxWidth"];
      new = ["window" "documentation" "max_width"];
    }
    {
      old = ["window" "documentation" "maxHeight"];
      new = ["window" "documentation" "max_height"];
    }
    {old = ["experimental"];}
  ];

  renameWarnings =
    map
    (
      rename:
        mkRenamedOptionModule
        (oldPluginBasePath ++ rename.old)
        (settingsPath ++ (rename.new or rename.old))
    )
    renamedOptions;
in {
  imports =
    renameWarnings
    ++ [
      (
        mkRemovedOptionModule
        (oldPluginBasePath ++ ["preselect"])
        ''
          Use `plugins.cmp.settings.preselect` option. But watch out, you now have to explicitly write `cmp.PreselectMode.<mode>`.
          See the option documentation for more details.
        ''
      )
      (
        mkRemovedOptionModule
        (oldPluginBasePath ++ ["mappingPresets"])
        "If you want to have a complex mapping logic, express it in raw lua within the `plugins.cmp.settings.mapping` option."
      )
      (
        mkRemovedOptionModule
        (oldPluginBasePath ++ ["snippet" "expand"])
        ''
          Use `plugins.cmp.settings.snippet.expand` option. But watch out, you can no longer put only the name of the snippet engine.
          If you use `luasnip` for instance, set:
          ```
            plugins.cmp.settings.snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          ```
        ''
      )
      (
        mkRemovedOptionModule
        (oldPluginBasePath ++ ["sorting" "comparators"])
        ''
          Use `plugins.cmp.settings.sorting.comparators` option. But watch out, you can no longer put only the name of the comparators.
          See the option documentation for more details.
        ''
      )
      (
        mkRemovedOptionModule
        (oldPluginBasePath ++ ["sources"])
        ''
          Use `plugins.cmp.settings.sources` option. But watch out, you can no longer provide a list of lists of sources.
          For this type of use, directly write lua.
          See the option documentation for more details.
        ''
      )
    ];
}
