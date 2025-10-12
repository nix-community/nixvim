lib: {
  deprecateExtraOptions = true;

  optionsRenamedToSettings = map (lib.splitString ".") [
    "theme"

    "options.mappingKeys"
    "options.cursorColumn"
    "options.after"
    "options.emptyLinesBetweenMappings"
    "options.disableStatuslines"
    "options.paddings"

    "mappings.executeCommand"
    "mappings.openFile"
    "mappings.openFileSplit"
    "mappings.openSection"
    "mappings.openHelp"

    "colors.background"
    "colors.foldedSection"

    "parts"
  ];

  imports = [
    (
      let
        inherit (lib) mapAttrs mapAttrs' nameValuePair;
        inherit (lib.nixvim) ifNonNull' toSnakeCase;
        basePathAnd = lib.concat [
          "plugins"
          "startup"
        ];
        oldOptPath = basePathAnd [ "sections" ];
      in
      lib.mkChangedOptionModule oldOptPath
        (basePathAnd [
          "settings"
        ])
        (
          config:
          let
            old = lib.getAttrFromPath oldOptPath config;
          in
          ifNonNull' old (mapAttrs (_: (mapAttrs' (n: nameValuePair (toSnakeCase n)))) old)
        )
    )
  ];
}
