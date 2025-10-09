lib:
let
  inherit (lib)
    const
    genAttrs
    mapAttrs
    ;
  inherit (lib.nixvim) ifNonNull' mkRaw;
in
{
  deprecateExtraOptions = true;

  optionsRenamedToSettings =
    map (lib.splitString ".") [
      "window.border"
      "window.size"
      "window.position"
      "window.scrolloff"
      "window.sections.left.size"
      "window.sections.left.border"
      "window.sections.mid.size"
      "window.sections.mid.border"
      "window.sections.right.border"
      "window.sections.right.preview"

      "nodeMarkers.enabled"
      "nodeMarkers.icons.leaf"
      "nodeMarkers.icons.leafSelected"
      "nodeMarkers.icons.branch"
      "useDefaultMapping"

      "lsp.autoAttach"
      "lsp.preference"

      "sourceBuffer.followNode"
      "sourceBuffer.highlight"
      "sourceBuffer.reorient"
      "sourceBuffer.scrolloff"
    ]
    # Move icons to settings without changing case as icons are PascalCase in the plugin config
    ++
      map
        (
          x:
          genAttrs [ "old" "new" ] (const [
            "icons"
            x
          ])
        )
        [
          "File"
          "Module"
          "Namespace"
          "Package"
          "Class"
          "Method"
          "Property"
          "Field"
          "Constructor"
          "Enum"
          "Interface"
          "Function"
          "Variable"
          "Constant"
          "String"
          "Number"
          "Boolean"
          "Array"
          "Object"
          "Key"
          "Null"
          "EnumMember"
          "Struct"
          "Event"
          "Operator"
          "TypeParameter"
        ];

  imports =
    let
      basePathAnd = lib.concat [
        "plugins"
        "navbuddy"
      ];
    in
    [
      (lib.mkRemovedOptionModule (basePathAnd [ "keymapsSilent" ]) ''
        This option has never had any effect.
        Please remove it.
      '')
      (
        let
          oldOptPath = basePathAnd [ "mappings" ];
        in
        lib.mkChangedOptionModule oldOptPath
          (basePathAnd [
            "settings"
            "mappings"
          ])
          (
            config:
            let
              old = lib.getAttrFromPath oldOptPath config;
            in
            ifNonNull' old (
              mapAttrs (
                _: action:
                if builtins.isString action then mkRaw "require('nvim-navbuddy.actions').${action}()" else action
              ) old
            )
          )
      )
    ];
}
