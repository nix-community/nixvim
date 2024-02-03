{
  cfg,
  lib,
  helpers,
}:
with lib; let
  # Not very readable sorry
  # If null then null
  # If an attribute is a string, just treat it as lua code for that mapping
  # If an attribute is a module, create a mapping with cmp.mapping() using the action as the first input and the modes as the second.
  mapping' = let
    mappings =
      mapAttrs
      (
        key: action:
          helpers.mkRaw (
            if isString action
            then action
            else let
              inherit (action) modes;
              modesString =
                optionalString
                (
                  (modes != null)
                  && ((length modes) >= 1)
                )
                ("," + (helpers.toLuaObject modes));
            in "cmp.mapping(${action.action}${modesString})"
          )
      )
      cfg.mapping;

    luaMappings = helpers.toLuaObject mappings;

    wrapped =
      lists.fold
      (
        presetName: prevString: ''cmp.mapping.preset.${presetName}(${prevString})''
      )
      luaMappings
      cfg.mappingPresets;
  in
    helpers.mkRaw wrapped;

  sources' = let
    convertSourceAttrs = source:
      with source; {
        inherit
          name
          option
          ;
        keyword_length = keywordLength;
        keywordPattern =
          helpers.ifNonNull' keywordPattern (helpers.mkRaw "[[${keywordPattern}]]");
        trigger_characters = triggerCharacters;
        inherit priority;
        group_index = groupIndex;
        entry_filter = entryFilter;
      };
  in
    if cfg.sources == null || cfg.sources == []
    then null
    # List of lists of sources -> we use the `cmp.config.sources` helper
    else if isList (head cfg.sources)
    then let
      sourcesListofLists =
        map
        (map convertSourceAttrs)
        cfg.sources;
    in
      helpers.mkRaw "cmp.config.sources(${helpers.toLuaObject sourcesListofLists})"
    # List of sources
    else map convertSourceAttrs cfg.sources;
in
  with cfg;
    {
      performance = with performance; {
        inherit
          debounce
          throttle
          ;
        fetching_timeout = fetchingTimeout;
        async_budget = asyncBudget;
        max_view_entries = maxViewEntries;
      };
      inherit preselect;
      mapping = mapping';
      snippet = with snippet; {
        inherit expand;
      };
      completion = with completion; {
        keyword_length = keywordLength;
        keyword_pattern = keywordPattern;
        inherit
          autocomplete
          completeopt
          ;
      };
      confirmation = with confirmation; {
        get_commit_characters = getCommitCharacters;
      };
      formatting = with formatting; {
        expandable_indicator = expandableIndicator;
        inherit fields format;
      };
      matching = with matching; {
        disallow_fuzzy_matching = disallowFuzzyMatching;
        disallow_fullfuzzy_matching = disallowFullfuzzyMatching;
        disallow_partial_fuzzy_matching = disallowPartialFuzzyMatching;
        disallow_partial_matching = disallowPartialMatching;
        disallow_prefix_unmatching = disallowPrefixUnmatching;
      };
      sorting = with sorting; {
        priority_weight = priorityWeight;
        inherit comparators;
      };
      sources = sources';
      view = with view; {
        inherit entries;
        docs = with docs; {
          auto_open = autoOpen;
        };
      };
      window = with window; {
        completion = with completion; {
          inherit
            border
            winhighlight
            zindex
            scrolloff
            ;
          col_offset = colOffset;
          side_padding = sidePadding;
          inherit scrollbar;
        };
        documentation = with documentation; {
          inherit
            border
            winhighlight
            zindex
            ;
          max_width = maxWidth;
          max_height = maxHeight;
        };
      };
      inherit experimental;
    }
    // cfg.extraOptions
