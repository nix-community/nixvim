{ lib, ... }:
let
  inherit (lib) mkRenamedOptionModule mkRemovedOptionModule;

  oldPluginBasePath = [
    "plugins"
    "nvim-cmp"
  ];
  newPluginBasePath = [
    "plugins"
    "cmp"
  ];
  settingsPath = newPluginBasePath ++ [ "settings" ];

  renamedOptions = [
    [
      "performance"
      "debounce"
    ]
    [
      "performance"
      "throttle"
    ]
    [
      "performance"
      "fetchingTimeout"
    ]
    [
      "performance"
      "asyncBudget"
    ]
    [
      "performance"
      "maxViewEntries"
    ]
    "mapping"
    [
      "completion"
      "keywordLength"
    ]
    [
      "completion"
      "keywordPattern"
    ]
    [
      "completion"
      "autocomplete"
    ]
    [
      "completion"
      "completeopt"
    ]
    [
      "confirmation"
      "getCommitCharacters"
    ]
    [
      "formatting"
      "expandableIndicator"
    ]
    [
      "formatting"
      "fields"
    ]
    [
      "formatting"
      "format"
    ]
    [
      "matching"
      "disallowFuzzyMatching"
    ]
    [
      "matching"
      "disallowFullfuzzyMatching"
    ]
    [
      "matching"
      "disallowPartialFuzzyMatching"
    ]
    [
      "matching"
      "disallowPartialMatching"
    ]
    [
      "matching"
      "disallowPrefixUnmatching"
    ]
    [
      "sorting"
      "priorityWeight"
    ]
    [
      "view"
      "entries"
    ]
    [
      "view"
      "docs"
      "autoOpen"
    ]
    [
      "window"
      "completion"
      "border"
    ]
    [
      "window"
      "completion"
      "winhighlight"
    ]
    [
      "window"
      "completion"
      "zindex"
    ]
    [
      "window"
      "completion"
      "scrolloff"
    ]
    [
      "window"
      "completion"
      "colOffset"
    ]
    [
      "window"
      "completion"
      "sidePadding"
    ]
    [
      "window"
      "completion"
      "scrollbar"
    ]
    [
      "window"
      "documentation"
      "border"
    ]
    [
      "window"
      "documentation"
      "winhighlight"
    ]
    [
      "window"
      "documentation"
      "zindex"
    ]
    [
      "window"
      "documentation"
      "maxWidth"
    ]
    [
      "window"
      "documentation"
      "maxHeight"
    ]
    "experimental"
  ];

  renameWarnings =
    lib.nixvim.mkSettingsRenamedOptionModules oldPluginBasePath settingsPath
      renamedOptions;
in
{
  imports = renameWarnings ++ [
    # auto-enable was removed 2025-02-07
    ./deprecated-auto-enable.nix
    (mkRenamedOptionModule (oldPluginBasePath ++ [ "enable" ]) (newPluginBasePath ++ [ "enable" ]))
    (mkRenamedOptionModule (oldPluginBasePath ++ [ "autoEnableSources" ]) (
      newPluginBasePath ++ [ "autoEnableSources" ]
    ))
    (mkRemovedOptionModule (oldPluginBasePath ++ [ "preselect" ]) ''
      Use `plugins.cmp.settings.preselect` option. But watch out, you now have to explicitly write `cmp.PreselectMode.<mode>`.
      See the option documentation for more details.
    '')
    (mkRemovedOptionModule (oldPluginBasePath ++ [ "mappingPresets" ])
      "If you want to have a complex mapping logic, express it in raw lua within the `plugins.cmp.settings.mapping` option."
    )
    (mkRemovedOptionModule
      (
        oldPluginBasePath
        ++ [
          "snippet"
          "expand"
        ]
      )
      ''
        Use `plugins.cmp.settings.snippet.expand` option. But watch out, you can no longer put only the name of the snippet engine.
        If you use `luasnip` for instance, set:
        ```
          plugins.cmp.settings.snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        ```
      ''
    )
    (mkRemovedOptionModule
      (
        oldPluginBasePath
        ++ [
          "sorting"
          "comparators"
        ]
      )
      ''
        Use `plugins.cmp.settings.sorting.comparators` option. But watch out, you can no longer put only the name of the comparators.
        See the option documentation for more details.
      ''
    )
    (mkRemovedOptionModule (oldPluginBasePath ++ [ "sources" ]) ''
      Use `plugins.cmp.settings.sources` option. But watch out, you can no longer provide a list of lists of sources.
      For this type of use, directly write lua.
      See the option documentation for more details.
    '')
  ];
}
