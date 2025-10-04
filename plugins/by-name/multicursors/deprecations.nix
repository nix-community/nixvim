lib:
let
  # Helper function to transform key mappings with mkRaw wrapping
  mkMaps =
    value:
    lib.nixvim.ifNonNull' value (
      lib.mapAttrs (
        _key: mapping: with mapping; {
          method = if lib.isBool method then method else lib.nixvim.mkRaw method;
          inherit opts;
        }
      ) value
    );
in
{
  # TODO: added 2025-10-04
  deprecateExtraOptions = true;

  imports = [
    # Custom transformations for normalKeys, insertKeys, extendKeys
    (lib.mkChangedOptionModule
      [
        "plugins"
        "multicursors"
        "normalKeys"
      ]
      [
        "plugins"
        "multicursors"
        "settings"
        "normal_keys"
      ]
      (config: mkMaps (lib.getAttrFromPath [ "plugins" "multicursors" "normalKeys" ] config))
    )
    (lib.mkChangedOptionModule
      [
        "plugins"
        "multicursors"
        "insertKeys"
      ]
      [
        "plugins"
        "multicursors"
        "settings"
        "insert_keys"
      ]
      (config: mkMaps (lib.getAttrFromPath [ "plugins" "multicursors" "insertKeys" ] config))
    )
    (lib.mkChangedOptionModule
      [
        "plugins"
        "multicursors"
        "extendKeys"
      ]
      [
        "plugins"
        "multicursors"
        "settings"
        "extend_keys"
      ]
      (config: mkMaps (lib.getAttrFromPath [ "plugins" "multicursors" "extendKeys" ] config))
    )
  ];

  optionsRenamedToSettings = [
    "debugMode"
    "createCommands"
    "updatetime"
    "nowait"
    [
      "hintConfig"
      "type"
    ]
    [
      "hintConfig"
      "position"
    ]
    [
      "hintConfig"
      "offset"
    ]
    [
      "hintConfig"
      "border"
    ]
    [
      "hintConfig"
      "showName"
    ]
    [
      "hintConfig"
      "funcs"
    ]
    [
      "generateHints"
      "normal"
    ]
    [
      "generateHints"
      "insert"
    ]
    [
      "generateHints"
      "extend"
    ]
  ];
}
