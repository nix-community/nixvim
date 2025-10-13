lib: {
  # NOTE: extraOptions was not used along with `require('wilder').setup` but with the `set_option` logic
  # It is replaced by the `plugins.wilder.options` option.
  deprecateExtraOptions = false;

  imports =
    let
      basePluginPath = [
        "plugins"
        "wilder"
      ];
      settingsPath = basePluginPath ++ [ "settings" ];
      optionsPath = basePluginPath ++ [ "options" ];

      mkKeymapRename =
        oldOptName: newOptName:
        let
          oldPath = basePluginPath ++ [ oldOptName ];
          newPath = settingsPath ++ [ newOptName ];
          convert =
            v:
            if lib.isAttrs v then
              let
                newValue = [
                  v.key
                  v.fallback
                ];
              in
              lib.warn ''
                WARNING: the `${lib.showOption newPath}` will not automatically process the provided input.
                You will need to provide the value as a list `${
                  lib.generators.toPretty { multiline = false; } newValue
                }`.
              '' newValue
            else
              v;
        in
        lib.mkChangedOptionModule oldPath newPath (config: (convert (lib.getAttrFromPath oldPath config)));

      keymapRenames = lib.mapAttrsToList mkKeymapRename {
        nextKey = "next_key";
        prevKey = "previous_key";
        acceptKey = "accept_key";
        rejectKey = "reject_key";
      };

      mkLuaOptionRename =
        oldOptName: newOptName:
        let
          oldPath = basePluginPath ++ [ oldOptName ];
          newPath = optionsPath ++ [ newOptName ];
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
        );
      optionRenames =
        (lib.mapAttrsToList mkLuaOptionRename {
          renderer = "renderer";
          preHook = "pre_hook";
          postHook = "post_hook";
        })
        ++ [
          (
            let
              oldPath = basePluginPath ++ [ "pipeline" ];
              newPath = optionsPath ++ [ "pipeline" ];
            in
            lib.mkChangedOptionModule oldPath newPath (
              config:
              let
                oldValue = lib.getAttrFromPath oldPath config;
              in
              if lib.isList oldValue then
                lib.warn ''
                  WARNING: `${lib.showOption newPath}` will not convert list elements to raw lua strings.
                '' map lib.nixvim.mkRaw oldValue
              else
                oldValue
            )
          )
        ]
        ++ (lib.nixvim.mkSettingsRenamedOptionModules basePluginPath optionsPath [
          "useCmdlinechanged"
          "interval"
          "beforeCursor"
          "usePythonRemotePlugin"
          "numWorkers"
        ]);
    in
    keymapRenames
    ++ optionRenames
    ++ [
      (lib.mkRenamedOptionModule (basePluginPath ++ [ "extraOptions" ]) (basePluginPath ++ [ "options" ]))
    ];

  optionsRenamedToSettings = [
    "enableCmdlineEnter"
    "modes"
    "wildcharm"
    "acceptCompletionAutoSelect"
  ];
}
