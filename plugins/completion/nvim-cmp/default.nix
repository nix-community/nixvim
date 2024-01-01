{
  lib,
  helpers,
  pkgs,
  config,
  ...
} @ args:
with lib; let
  cfg = config.plugins.nvim-cmp;
  cmpLib = import ./cmp-helpers.nix args;

  snippetEngines = {
    "vsnip" = ''vim.fn["vsnip#anonymous"](args.body)'';
    "luasnip" = ''require('luasnip').lsp_expand(args.body)'';
    "snippy" = ''require('snippy').expand_snippet(args.body)'';
    "ultisnips" = ''vim.fn["UltiSnips#Anon"](args.body)'';
  };
in {
  options.plugins.nvim-cmp =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "nvim-cmp";

      package = helpers.mkPackageOption "nvim-cmp" pkgs.vimPlugins.nvim-cmp;

      performance = {
        debounce = helpers.defaultNullOpts.mkInt 60 ''
          Sets debounce time
          This is the interval used to group up completions from different sources
          for filtering and displaying.
        '';

        throttle = helpers.defaultNullOpts.mkInt 30 ''
          Sets throttle time.
          This is used to delay filtering and displaying completions.
        '';

        fetchingTimeout = helpers.defaultNullOpts.mkInt 500 ''
          Sets the timeout of candidate fetching process.
          The nvim-cmp will wait to display the most prioritized source.
        '';

        asyncBudget = helpers.defaultNullOpts.mkInt 1 ''
          Maximum time (in ms) an async function is allowed to run during one step of the event loop.
        '';

        maxViewEntries = helpers.defaultNullOpts.mkInt 200 ''
          Maximum number of items to show in the entries list.
        '';
      };

      preselect = helpers.defaultNullOpts.mkEnumFirstDefault ["Item" "None"] ''
        - "Item": nvim-cmp will preselect the item that the source specified.
        - "None": nvim-cmp will not preselect any items.
      '';

      mapping = mkOption {
        default = null;
        type = with types;
          nullOr
          (
            attrsOf
            (
              either
              str
              (
                submodule {
                  options = {
                    action = mkOption {
                      type = nonEmptyStr;
                      description = "The function the mapping should call";
                      example = ''"cmp.mapping.scroll_docs(-4)"'';
                    };
                    modes = mkOption {
                      default = null;
                      type = nullOr (listOf str);
                      example = ''[ "i" "s" ]'';
                    };
                  };
                }
              )
            )
          );
        example = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
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

      mappingPresets = mkOption {
        default = [];
        type = types.listOf (types.enum [
          "insert"
          "cmdline"
        ]);
        description = ''
          Mapping presets to use; cmp.mapping.preset.
          \$\{mappingPreset} will be called with the configured mappings.
        '';
        example = ''[ "insert" "cmdline" ]'';
      };

      snippet = {
        expand =
          helpers.mkNullOrOption
          (
            with types;
              either
              helpers.nixvimTypes.rawLua
              (enum (attrNames snippetEngines))
          )
          ''
            The snippet expansion function. That's how nvim-cmp interacts with a
            particular snippet engine.

            You may directly provide one of those four supported engines:
            - vsnip
            - luasnip
            - snippy
            - ultisnips

            You can also provide a custom function:
            ```nix
            {
              __raw = \'\'
                function(args)
                  vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                  -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                  -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                  -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end
              \'\';
            };
            ```
          '';
      };

      completion = {
        keywordLength = helpers.defaultNullOpts.mkInt 1 ''
          The number of characters needed to trigger auto-completion.
        '';

        keywordPattern =
          helpers.defaultNullOpts.mkStr
          ''\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)''
          ''
            The default keyword pattern.

            Note: the provided pattern will be embedded as such: `[[PATTERN]]`.
          '';

        autocomplete =
          helpers.defaultNullOpts.mkNullable
          (
            with types;
              either
              (listOf str)
              (types.enum [false])
          )
          ''[ "TextChanged" ]''
          ''
            The event to trigger autocompletion.
            If set to `"false"`, then completion is only invoked manually
            (e.g. by calling `cmp.complete`).
          '';

        completeopt = helpers.defaultNullOpts.mkStr "menu,menuone,noselect" ''
          Like vim's completeopt setting. In general, you don't need to change this.
        '';
      };

      confirmation = {
        getCommitCharacters =
          helpers.defaultNullOpts.mkStr
          ''
            function(commit_characters)
              return commit_characters
            end
          ''
          ''
            You can append or exclude commitCharacters via this configuration option
            function. The commitCharacters are defined by the LSP spec.
          '';
      };

      formatting = {
        expandableIndicator = helpers.defaultNullOpts.mkBool true ''
          Boolean to show the `~` expandable indicator in cmp's floating window.
        '';

        fields =
          helpers.defaultNullOpts.mkNullable
          (with types; listOf str)
          ''[ "kind" "abbr" "menu" ]''
          "An array of completion fields to specify their order.";

        format =
          helpers.defaultNullOpts.mkLuaFn
          ''
            function(_, vim_item)
              return vim_item
            end
          ''
          ''
            `fun(entry: cmp.Entry, vim_item: vim.CompletedItem): vim.CompletedItem`
            The function used to customize the appearance of the completion menu. See
            |complete-items|. This value can also be used to modify the `dup` property.
            NOTE: The `vim.CompletedItem` can contain the special properties
            `abbr_hl_group`, `kind_hl_group` and `menu_hl_group`.
          '';
      };

      matching = {
        disallowFuzzyMatching = helpers.defaultNullOpts.mkBool false ''
          Whether to allow fuzzy matching.
        '';

        disallowFullfuzzyMatching = helpers.defaultNullOpts.mkBool false ''
          Whether to allow full-fuzzy matching.
        '';

        disallowPartialFuzzyMatching = helpers.defaultNullOpts.mkBool true ''
          Whether to allow fuzzy matching without prefix matching.
        '';

        disallowPartialMatching = helpers.defaultNullOpts.mkBool false ''
          Whether to allow partial matching.
        '';

        disallowPrefixUnmatching = helpers.defaultNullOpts.mkBool false ''
          Whether to allow prefix unmatching.
        '';
      };

      sorting = {
        priorityWeight = helpers.defaultNullOpts.mkInt 2 ''
          Each item's original priority (given by its corresponding source) will be
          increased by `#sources - (source_index - 1)` and multiplied by `priority_weight`.
          That is, the final priority is calculated by the following formula:

          `final_score = orig_score + ((#sources - (source_index - 1)) * sorting.priority_weight)`
        '';

        comparators =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str)
          ''[ "offset" "exact" "score" "recently_used" "locality" "kind" "length" "order" ]''
          ''
            The function to customize the sorting behavior.
            You can use built-in comparators via `cmp.config.compare.*`.

            Signature: `(fun(entry1: cmp.Entry, entry2: cmp.Entry): boolean | nil)[]`
          '';
      };

      autoEnableSources = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Scans the sources array and installs the plugins if they are known to nixvim.
        '';
      };

      sources = let
        source_config = types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = "The name of the source.";
              example = "buffer";
            };

            option = helpers.mkNullOrOption types.attrs ''
              Any specific options defined by the source itself.

              If direct lua code is needed use `helpers.mkRaw`.
            '';

            keywordLength = helpers.mkNullOrOption types.int ''
              The source-specific keyword length to trigger auto completion.
            '';

            keywordPattern = helpers.mkNullOrOption types.str ''
              The source-specific keyword pattern.

              Note: the provided pattern will be embedded as such: `[[PATTERN]]`.
            '';

            triggerCharacters = helpers.mkNullOrOption (with types; listOf str) ''
              A source-specific keyword pattern.
            '';

            priority = helpers.mkNullOrOption types.int "The source-specific priority value.";

            groupIndex = helpers.mkNullOrOption types.int ''
              The source group index.

              For instance, you can set the `buffer`'s source `groupIndex` to a larger number
              if you don't want to see `buffer` source items while `nvim-lsp` source is available:

              ```nix
                sources = [
                  {
                    name = "nvim_lsp";
                    groupIndex = 1;
                  }
                  {
                    name = "buffer";
                    groupIndex = 2;
                  }
                ];
              ```
            '';

            entryFilter = helpers.mkNullOrOption types.str ''
              A source-specific entry filter, with the following function signature:

              `function(entry: cmp.Entry, ctx: cmp.Context): boolean`

              Returning `true` will keep the entry, while returning `false` will remove it.

              This can be used to hide certain entries from a given source. For instance, you
              could hide all entries with kind `Text` from the `nvim_lsp` filter using the
              following source definition:

              ```
              {
                name = 'nvim_lsp',
                entry_filter = function(entry, ctx)
                  return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
                end
              }
              ```

              Using the `ctx` parameter, you can further customize the behaviour of the source.
            '';
          };
        };
      in
        mkOption {
          default = null;
          type = with types;
            nullOr
            (
              listOf
              (
                either
                source_config
                (listOf source_config)
              )
            );
          description = ''
            The sources to use.
            Can either be a list of sourceConfigs which will be made directly to a Lua object.
            Or it can be a list of lists, which will use the cmp built-in helper function
            `cmp.config.sources`.

            Default: `[]`
          '';
          example = ''
            [
              { name = "nvim_lsp"; }
              { name = "luasnip"; } #For luasnip users.
              { name = "path"; }
              { name = "buffer"; }
            ]
          '';
        };

      view = {
        entries =
          helpers.defaultNullOpts.mkNullable (with types; either str attrs)
          ''
            {
              name = "custom";
              selection_order = "top_down";
            }
          ''
          ''
            The view class used to customize nvim-cmp's appearance.
          '';

        docs = {
          autoOpen = helpers.defaultNullOpts.mkBool true ''
            Specify whether to show the docs_view when selecting an item.
          '';
        };
      };

      window = let
        # Reusable options
        mkWinhighlightOption = default:
          helpers.defaultNullOpts.mkStr
          default
          ''
            Specify the window's winhighlight option.
            See |nvim_open_win|.
          '';

        zindex = helpers.mkNullOrOption types.int ''
          The completion window's zindex.
          See |nvim_open_win|.
        '';
      in {
        completion = {
          border =
            helpers.defaultNullOpts.mkBorder
            ''[ "" "" "" "" "" "" "" "" ]''
            "nvim-cmp window"
            "";

          winhighlight =
            mkWinhighlightOption
            "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None";

          inherit zindex;

          scrolloff = helpers.defaultNullOpts.mkInt 0 ''
            Specify the window's scrolloff option.
            See |'scrolloff'|.
          '';

          colOffset = helpers.defaultNullOpts.mkInt 0 ''
            Offsets the completion window relative to the cursor.
          '';

          sidePadding = helpers.defaultNullOpts.mkInt 1 ''
            The amount of padding to add on the completion window's sides.
          '';

          scrollbar = helpers.defaultNullOpts.mkBool true ''
            Whether the scrollbar should be enabled if there are more items that fit
          '';
        };

        documentation = {
          border =
            helpers.defaultNullOpts.mkBorder
            ''[ "" "" "" " " "" "" "" " " ]''
            "nvim-cmp documentation window"
            "";

          winhighlight = mkWinhighlightOption "FloatBorder:NormalFloat";

          inherit zindex;

          maxWidth =
            helpers.defaultNullOpts.mkNullable
            (with types; either int str)
            "math.floor((40 * 2) * (vim.o.columns / (40 * 2 * 16 / 9)))"
            "The documentation window's max width.";

          maxHeight =
            helpers.defaultNullOpts.mkNullable
            (with types; either int str)
            "math.floor(40 * (40 / vim.o.lines))"
            "The documentation window's max height.";
        };
      };

      # This can be kept as types.attrs since experimental features are often removed or completely
      # changed after a while
      experimental = helpers.mkNullOrOption types.attrs "Experimental features";
    };

  config = let
    setupOptions = with cfg;
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
        preselect =
          helpers.ifNonNull' preselect
          (helpers.mkRaw "cmp.PreselectMode.${preselect}");

        # Not very readable sorry
        # If null then null
        # If an attribute is a string, just treat it as lua code for that mapping
        # If an attribute is a module, create a mapping with cmp.mapping() using the action as the first input and the modes as the second.
        mapping = let
          mappings =
            helpers.ifNonNull' mapping
            (mapAttrs
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
              mapping);

          luaMappings = helpers.toLuaObject mappings;

          wrapped =
            lists.fold
            (
              presetName: prevString: ''cmp.mapping.preset.${presetName}(${prevString})''
            )
            luaMappings
            mappingPresets;
        in
          helpers.mkRaw wrapped;

        snippet = with snippet; {
          expand =
            if isString expand
            then
              helpers.mkRaw ''
                function(args)
                  ${snippetEngines.${expand}}
                end
              ''
            else expand;
        };

        completion = with completion; {
          keyword_length = keywordLength;
          keyword_pattern =
            helpers.ifNonNull' keywordPattern
            (helpers.mkRaw "[[${keywordPattern}]]");
          autocomplete =
            if isList autocomplete
            then
              map
              (triggerEvent:
                helpers.mkRaw "require('cmp.types').cmp.TriggerEvent.${triggerEvent}")
              autocomplete
            # either null or false
            else autocomplete;
          inherit completeopt;
        };

        confirmation = with confirmation; {
          get_commit_characters =
            if (isString getCommitCharacters)
            then helpers.mkRaw getCommitCharacters
            else getCommitCharacters;
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
          comparators =
            helpers.ifNonNull' comparators
            (
              map
              (
                funcName:
                  helpers.mkRaw "require('cmp.config.compare').${funcName}"
              )
              comparators
            );
        };

        sources = let
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
          if sources == null || sources == []
          then null
          # List of lists of sources -> we use the `cmp.config.sources` helper
          else if isList (head sources)
          then let
            sourcesListofLists =
              map
              (map convertSourceAttrs)
              sources;
          in
            helpers.mkRaw "cmp.config.sources(${helpers.toLuaObject sourcesListofLists})"
          # List of sources
          else map convertSourceAttrs sources;

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
            max_width =
              if isInt maxWidth
              then maxWidth
              else helpers.mkRaw maxWidth;
            max_height =
              if isInt maxHeight
              then maxHeight
              else helpers.mkRaw maxHeight;
          };
        };
        inherit experimental;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = helpers.wrapDo ''
        local cmp = require('cmp')
        cmp.setup(${helpers.toLuaObject setupOptions})
      '';

      # If autoEnableSources is set to true, figure out which are provided by the user
      # and enable the corresponding plugins.
      plugins = let
        sourcesFlattenedList =
          if cfg.sources == null
          then []
          else flatten cfg.sources;

        # Take only the names from the sources provided by the user
        foundSources =
          lists.unique
          (
            map
            (source: source.name)
            sourcesFlattenedList
          );

        # A list of known source names
        knownSourceNames = attrNames cmpLib.pluginAndSourceNames;

        attrsEnabled = listToAttrs (map
          (name: {
            # Name of the corresponding plugin to enable
            name = cmpLib.pluginAndSourceNames.${name};

            # Whether or not we enable it
            value.enable = mkIf (elem name foundSources) true;
          })
          knownSourceNames);
      in
        mkMerge [
          (mkIf cfg.autoEnableSources attrsEnabled)
          (mkIf (elem "nvim_lsp" foundSources)
            {
              lsp.capabilities = ''
                capabilities = require('cmp_nvim_lsp').default_capabilities()
              '';
            })
        ];
    };
}
