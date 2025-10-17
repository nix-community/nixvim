lib: {
  imports =
    let
      basePluginPath = [
        "plugins"
        "treesitter-textobjects"
      ];
      settingsPath = basePluginPath ++ [ "settings" ];

      mkChangedKeymapOption =
        oldSubPath: newSubPath:
        let
          oldPath = basePluginPath ++ oldSubPath;
          newPath = settingsPath ++ newSubPath;

          processKeymaps = lib.mapAttrs (
            key: mapping:
            if lib.isString mapping then
              mapping
            else
              lib.warn
                ''
                  WARNING: `${lib.showOption newPath}` will expect `query_group` instead of `queryGroup`.
                ''
                {
                  inherit (mapping) query;
                  query_group = mapping.queryGroup;
                  inherit (mapping) desc;
                }
          );
        in
        lib.mkChangedOptionModule oldPath newPath (
          config:
          let
            oldValue = lib.getAttrFromPath oldPath config;
          in
          (if oldValue == null then lib.id else processKeymaps) oldValue
        );
    in
    [
      (
        let
          oldPath = basePluginPath ++ [
            "select"
            "includeSurroundingWhitespace"
          ];
          newPath = settingsPath ++ [
            "select"
            "include_surrounding_whitespace"
          ];
        in
        lib.mkChangedOptionModule oldPath newPath (
          config:
          let
            oldValue = lib.getAttrFromPath oldPath config;
          in
          (
            if lib.isString oldValue then
              lib.warn ''
                WARNING: `${lib.showOption newPath}` will not convert the value to a raw lua string.
              '' lib.nixvim.mkRaw
            else
              lib.id
          )
            oldValue
        )
      )
      (mkChangedKeymapOption [ "select" "keymaps" ] [ "select" "keymaps" ])
      (mkChangedKeymapOption [ "swap" "swapNext" ] [ "swap" "swap_next" ])
      (mkChangedKeymapOption [ "swap" "swapPrevious" ] [ "swap" "swap_previous" ])
      (mkChangedKeymapOption [ "move" "gotoNextStart" ] [ "move" "goto_next_start" ])
      (mkChangedKeymapOption [ "move" "gotoNextEnd" ] [ "move" "goto_next_end" ])
      (mkChangedKeymapOption [ "move" "gotoPreviousStart" ] [ "move" "goto_previous_start" ])
      (mkChangedKeymapOption [ "move" "gotoPreviousEnd" ] [ "move" "goto_previous_end" ])
      (mkChangedKeymapOption [ "move" "gotoNext" ] [ "move" "goto_next" ])
      (mkChangedKeymapOption [ "move" "gotoPrevious" ] [ "move" "goto_previous" ])
      (mkChangedKeymapOption
        [ "lspInterop" "peekDefinitionCode" ]
        [ "lsp_interop" "peek_definition_code" ]
      )
    ];

  deprecateExtraOptions = true;

  optionsRenamedToSettings = lib.map (lib.splitString ".") [
    "select.enable"
    "select.disable"
    "select.lookahead"
    "select.selectionModes"

    "swap.enable"
    "swap.disable"

    "move.enable"
    "move.disable"
    "move.setJumps"

    "lspInterop.enable"
    "lspInterop.border"
    "lspInterop.floatingPreviewOpts"
  ];
}
